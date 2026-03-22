#!/usr/bin/env node
/**
 * 元器件价格查询工具
 * 用法：
 *   node query-price.js              # 查询监控清单中所有 MPN
 *   node query-price.js <MPN>        # 查询指定 MPN
 */

const fs = require('fs');
const path = require('path');
const https = require('https');

const WATCHLIST_PATH = path.join(__dirname, '../data/watchlist.json');
const MOUSER_API_KEY = '4fe47ba4-9c76-4e20-9443-08e82f79ad33';

// 读取监控清单
function readWatchlist() {
  try {
    const data = fs.readFileSync(WATCHLIST_PATH, 'utf-8');
    return JSON.parse(data);
  } catch (error) {
    return { items: [], max_items: 10 };
  }
}

// 调用 Mouser API
function searchMouser(partNumbers) {
  return new Promise((resolve, reject) => {
    const postData = JSON.stringify({
      SearchByPartRequest: {
        mouserPartNumber: partNumbers.join(','),
        partSearchOptions: 'None'
      }
    });

    const options = {
      hostname: 'api.mouser.com',
      port: 443,
      path: `/api/v1/search/partnumber?apiKey=${MOUSER_API_KEY}`,
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Content-Length': Buffer.byteLength(postData)
      }
    };

    const req = https.request(options, (res) => {
      let data = '';
      res.on('data', (chunk) => { data += chunk; });
      res.on('end', () => {
        try {
          const result = JSON.parse(data);
          if (result.SearchResults && result.SearchResults.Parts) {
            resolve({ success: true, parts: result.SearchResults.Parts });
          } else {
            resolve({ success: false, errors: result.Errors || ['No results'] });
          }
        } catch (error) {
          reject({ error: error.message });
        }
      });
    });

    req.on('error', (error) => reject({ error: error.message }));
    req.setTimeout(15000, () => {
      req.destroy();
      reject({ error: 'Request timeout' });
    });

    req.write(postData);
    req.end();
  });
}

// 解析价格
function parsePrice(part) {
  if (!part.PriceBreaks || part.PriceBreaks.length === 0) {
    return { price: null, priceWithTax: null, quantity: null };
  }

  // 取最后一个阶梯（最高批量价）
  const lastBreak = part.PriceBreaks[part.PriceBreaks.length - 1];
  const priceStr = lastBreak.Price.replace(/[^\d.]/g, '');
  const price = parseFloat(priceStr);
  const priceWithTax = price * 1.13; // 13% 税

  return {
    price: price,
    priceWithTax: priceWithTax,
    quantity: lastBreak.Quantity
  };
}

// 解析库存
function parseStock(availability) {
  if (!availability) return 0;
  const match = availability.match(/(\d+)/);
  return match ? parseInt(match[1]) : 0;
}

// 格式化输出
function formatResult(mpn, part) {
  const priceInfo = parsePrice(part);
  const stock = parseStock(part.Availability);
  
  if (!priceInfo.price) {
    return `❌ ${mpn}: 未找到价格信息`;
  }

  const lines = [];
  lines.push(`✅ ${mpn}`);
  lines.push(`   品牌：${part.Manufacturer || 'N/A'}`);
  lines.push(`   批量价格 (${priceInfo.quantity}+片)：¥${priceInfo.price.toFixed(2)} (不含税)`);
  lines.push(`   含税价格 (${priceInfo.quantity}+片)：¥${priceInfo.priceWithTax.toFixed(2)} (含13%税)`);
  lines.push(`   库存：${stock} | 交期：${part.LeadTime || 'N/A'}`);
  
  return lines.join('\n');
}

// 主程序
async function main() {
  const args = process.argv.slice(2);
  
  let mpnList = [];
  
  if (args.length > 0) {
    // 查询指定的 MPN
    mpnList = args.map(m => m.toUpperCase());
  } else {
    // 从监控清单读取
    const watchlist = readWatchlist();
    mpnList = watchlist.items.filter(item => item.enabled).map(item => item.mpn);
  }

  if (mpnList.length === 0) {
    console.log('📋 监控清单为空');
    console.log('');
    console.log('💡 使用以下命令添加 MPN：');
    console.log('   node manage-list.js add <MPN>');
    return;
  }

  console.log('========================================');
  console.log('📊 元器件价格查询');
  console.log(`⏰ ${new Date().toLocaleString('zh-CN', { timeZone: 'Asia/Shanghai' })}`);
  console.log('========================================');
  console.log('');
  console.log(`📦 查询数量：${mpnList.length}`);
  console.log('');

  // 批量查询（Mouser API 限制每次最多 10 个）
  if (mpnList.length > 10) {
    console.log('⚠️  最多查询 10 个料号，将只查询前 10 个');
    mpnList = mpnList.slice(0, 10);
  }

  console.log('🔍 查询 Mouser...');
  
  try {
    const result = await searchMouser(mpnList);
    
    if (!result.success) {
      console.log('❌ 查询失败：', result.errors);
      return;
    }

    console.log(`✅ 找到 ${result.parts.length} 个结果\n`);

    // 创建查找表
    const partsMap = {};
    for (const part of result.parts) {
      const mpn = part.ManufacturerPartNumber.toUpperCase();
      partsMap[mpn] = part;
      // 也用 Mouser 料号索引
      partsMap[part.MouserPartNumber] = part;
    }

    // 输出每个 MPN 的结果
    let found = 0;
    let notFound = 0;

    for (const mpn of mpnList) {
      const part = partsMap[mpn] || partsMap[Object.keys(partsMap).find(k => k.includes(mpn))];
      
      if (part) {
        console.log(formatResult(mpn, part));
        found++;
      } else {
        console.log(`⚠️  ${mpn}: 未找到`);
        notFound++;
      }
      console.log('');
    }

    // 摘要
    console.log('========================================');
    console.log('📊 查询摘要');
    console.log('========================================');
    console.log(`总计：${mpnList.length} 个`);
    console.log(`找到：${found} 个`);
    console.log(`未找到：${notFound} 个`);

  } catch (error) {
    console.log('❌ 查询出错：', error.error || error);
  }
}

main();