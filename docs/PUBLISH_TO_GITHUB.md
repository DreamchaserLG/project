# 发布到 GitHub

## 发布前检查

请先确认这些本地敏感文件没有被加入 Git：

- `src/main/resources/application-local.yml`
- `src/main/resources/static/admin/.env.local`
- `src/main/resources/static/home/.env.local`
- `maven/`
- `target/`
- `logs/`
- `data_backup_before_refresh.sql`
- `LOCAL_RUN.md`

## 初始化 Git 仓库

如果当前目录还不是 Git 仓库：

```bash
git init -b main
```

## 提交代码

```bash
git add .
git status
git commit -m "chore: prepare expo management system for open source release"
```

## 在 GitHub 创建空仓库

在 GitHub 网页上创建一个新的空仓库，不要勾选 README、.gitignore、License 初始化，这样最省事。

创建完成后执行：

```bash
git remote add origin <your-github-repo-url>
git push -u origin main
```

## 建议补充

公开发布前建议再确认：

1. 仓库名称是否和论文题目一致
2. README 是否写清楚运行方式
3. 是否需要添加 LICENSE
4. 是否需要把演示账号密码写进 README
5. 是否要保留 `refresh_demo_content.sql` 和 `waitlist_demo.sql` 作为演示数据
