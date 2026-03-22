#!/usr/bin/env node
/**
 * 元器件监控清单管理工具
 * 用法：
 *   node manage-list.js list           # 查看清单
 *   node manage-list.js add <MPN>      # 添加 MPN
 *   node manage-list.js remove <MPN>   # 删除 MPN
 *   node manage-list.js clear          # 清空清单
 */

const fs = require('fs');
const path = require('path');

const WATCHLIST_PATH = path.join(__dirname, '../data/watchlist.json');
const MAX_ITEMS = 10;

// 读取清单
function readList() {
  try {
    const data = fs.readFileSync(WATCHLIST_PATH, 'utf-8');
    return JSON.parse(data);
  } catch (error) {
    // 文件不存在，创建空清单
    const emptyList = { items: [], max_items: MAX_ITEMS };
    fs.writeFileSync(WATCHLIST_PATH, JSON.stringify(emptyList, null, 2));
    return emptyList;
  }
}

// 保存清单
function saveList(list) {
  fs.writeFileSync(WATCHLIST_PATH, JSON.stringify(list, null, 2));
}

// 查看清单
function listItems() {
  const list = readList();
  
  if (list.items.length === 0) {
    console.log('📋 监控清单为空');
    console.log('');
    console.log('💡 使用以下命令添加 MPN：');
    console.log('   node manage-list.js add <MPN>');
    return;
  }
  
  console.log(`📋 监控清单 (${list.items.length}/${MAX_ITEMS})：`);
  console.log('');
  list.items.forEach((item, index) => {
    const status = item.enabled ? '✅' : '⏸️';
    console.log(`${index + 1}. ${status} ${item.mpn}`);
    if (item.description) {
      console.log(`   描述：${item.description}`);
    }
  });
}

// 添加 MPN
function addItem(mpn, description = '') {
  const list = readList();
  
  // 检查是否已存在
  if (list.items.some(item => item.mpn.toUpperCase() === mpn.toUpperCase())) {
    console.log(`⚠️  ${mpn} 已在监控清单中`);
    return false;
  }
  
  // 检查是否已满
  if (list.items.length >= MAX_ITEMS) {
    console.log(`❌ 监控清单已满 (${MAX_ITEMS}/${MAX_ITEMS})`);
    console.log('');
    console.log('请先删除一个 MPN：');
    list.items.forEach((item, index) => {
      console.log(`   ${index + 1}. ${item.mpn}`);
    });
    console.log('');
    console.log('使用命令：node manage-list.js remove <MPN>');
    return false;
  }
  
  // 添加新项
  list.items.push({
    mpn: mpn.toUpperCase(),
    description: description,
    added_at: new Date().toISOString(),
    enabled: true
  });
  
  saveList(list);
  console.log(`✅ 已添加 ${mpn} 到监控清单 (${list.items.length}/${MAX_ITEMS})`);
  return true;
}

// 删除 MPN
function removeItem(mpn) {
  const list = readList();
  
  const index = list.items.findIndex(item => item.mpn.toUpperCase() === mpn.toUpperCase());
  
  if (index === -1) {
    console.log(`⚠️  ${mpn} 不在监控清单中`);
    return false;
  }
  
  list.items.splice(index, 1);
  saveList(list);
  console.log(`✅ 已从监控清单删除 ${mpn} (${list.items.length}/${MAX_ITEMS})`);
  return true;
}

// 清空清单
function clearList() {
  const list = { items: [], max_items: MAX_ITEMS };
  saveList(list);
  console.log('✅ 监控清单已清空');
}

// 主程序
const args = process.argv.slice(2);
const command = args[0];
const param = args[1];

switch (command) {
  case 'list':
  case 'ls':
    listItems();
    break;
  case 'add':
    if (!param) {
      console.log('❌ 请提供 MPN');
      console.log('用法：node manage-list.js add <MPN>');
    } else {
      addItem(param, args[2] || '');
    }
    break;
  case 'remove':
  case 'rm':
    if (!param) {
      console.log('❌ 请提供 MPN');
      console.log('用法：node manage-list.js remove <MPN>');
    } else {
      removeItem(param);
    }
    break;
  case 'clear':
    clearList();
    break;
  default:
    console.log('📋 元器件监控清单管理工具');
    console.log('');
    console.log('用法：');
    console.log('  node manage-list.js list           # 查看清单');
    console.log('  node manage-list.js add <MPN>      # 添加 MPN');
    console.log('  node manage-list.js remove <MPN>   # 删除 MPN');
    console.log('  node manage-list.js clear          # 清空清单');
}