后端JavaScript（Node.js + Express）进行数据增删查改（CRUD）的示范代码，使用内存数组模拟数据存储，包含完整的REST API实现。

```javascript
const express = require('express');
const app = express();
app.use(express.json());  // 解析JSON请求体

// 模拟数据库（内存数组）
let items = [
  { id: 1, name: '示例数据1' },
  { id: 2, name: '示例数据2' }
];
let nextId = 3;  // 用于生成新ID

// 1. 查询所有数据（R - Read）
app.get('/api/items', (req, res) => {
  res.json(items);
});

// 2. 查询单条数据（R - Read）
app.get('/api/items/:id', (req, res) => {
  const id = parseInt(req.params.id);
  const item = items.find(i => i.id === id);
  if (!item) {
    return res.status(404).json({ error: '数据不存在' });
  }
  res.json(item);
});

// 3. 新增数据（C - Create）
app.post('/api/items', (req, res) => {
  const { name } = req.body;
  if (!name) {
    return res.status(400).json({ error: 'name字段不能为空' });
  }
  const newItem = { id: nextId++, name };
  items.push(newItem);
  res.status(201).json(newItem);
});

// 4. 修改数据（U - Update）
app.put('/api/items/:id', (req, res) => {
  const id = parseInt(req.params.id);
  const { name } = req.body;
  const item = items.find(i => i.id === id);
  if (!item) {
    return res.status(404).json({ error: '数据不存在' });
  }
  if (name) item.name = name;
  res.json(item);
});

// 5. 删除数据（D - Delete）
app.delete('/api/items/:id', (req, res) => {
  const id = parseInt(req.params.id);
  const index = items.findIndex(i => i.id === id);
  if (index === -1) {
    return res.status(404).json({ error: '数据不存在' });
  }
  items.splice(index, 1);
  res.status(204).send();  // 无内容响应
});

// 启动服务
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`服务器已启动，访问 http://localhost:${PORT}`);
});
```

### 配套的前端调用示例（使用fetch）
```javascript
// 查询所有
fetch('/api/items').then(res => res.json()).then(console.log);

// 新增
fetch('/api/items', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ name: '新数据' })
}).then(res => res.json()).then(console.log);

// 修改
fetch('/api/items/1', {
  method: 'PUT',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ name: '修改后的名称' })
}).then(res => res.json()).then(console.log);

// 删除
fetch('/api/items/2', { method: 'DELETE' });
```


