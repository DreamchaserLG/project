# 会展管理系统

基于 `Spring Boot + MySQL + Redis + Vue` 的会展管理系统，覆盖普通用户、主办用户和管理员三类角色，支持会展浏览、展位查询、在线报名、候补、退款申请、行程确认、公告通知和后台审核管理。

## 技术栈

- 后端：Spring Boot 2.2.5、MyBatis-Plus、Druid、Redis、MySQL
- 前端：Vue 2、Element UI、Vue CLI
- 运行环境：JDK 8、Node 22.17.0、npm 10.9.2

## 目录说明

- `src/main/java`：Spring Boot 后端源码
- `src/main/resources`：后端配置、Mapper、静态上传目录
- `frontend/admin`：管理员端前端
- `frontend/home`：用户端前端
- `sql/project.sql`：基础数据库脚本
- `sql/project_patch_local.sql`：数据库补丁脚本
- `sql/refresh_demo_content.sql`：演示内容修正脚本
- `sql/waitlist_demo.sql`：候补流程演示数据脚本

## 开源前隐私处理

本仓库已经通过 `.gitignore` 排除了这些本地敏感内容：

- `src/main/resources/application-local.yml`
- `frontend/admin/.env.local`
- `frontend/home/.env.local`
- `maven/`
- `target/`
- `logs/`
- `LOCAL_RUN.md`

在提交到 GitHub 之前，请确认你没有手动执行 `git add -f` 把这些文件强行加入版本库。

## 本地运行环境

另一台电脑建议安装：

- Git
- IntelliJ IDEA
- JDK 8
- Maven 3.6.1 及以上
- MySQL 8.0 或 5.7
- Redis 6.x 或兼容版本
- Node.js 22.17.0
- npm 10.9.2

## 快速部署

### 1. 克隆项目

```bash
git clone <your-github-repo-url>
cd project
```

### 2. 初始化数据库

先创建数据库 `project_db`，然后按顺序执行：

```bash
mysql -u root -p project_db < sql/project.sql
mysql -u root -p project_db < sql/project_patch_local.sql
mysql -u root -p project_db < sql/refresh_demo_content.sql   # 推荐，用于修正演示内容
mysql -u root -p project_db < sql/waitlist_demo.sql           # 可选，用于候补流程演示
```

### 3. 复制并填写本地配置

后端：

```bash
copy src\main\resources\application-local.example.yml src\main\resources\application-local.yml
```

前端：

```bash
copy frontend\admin\.env.example frontend\admin\.env.local
copy frontend\home\.env.example frontend\home\.env.local
```

需要填写的重点配置：

- MySQL 地址、账号、密码
- Redis 地址、密码
- 邮箱账号和授权码
- AMap Key、AI Key（仅在相关功能需要时配置）

### 4. 用 IDEA 启动后端

1. 使用 IDEA 打开项目根目录
2. 等待 Maven 依赖导入完成
3. 设置项目 JDK 为 `1.8`
4. 运行 `src/main/java/com/project/demo/Application.java`
5. 环境变量建议设置：`SPRING_PROFILES_ACTIVE=local`

默认后端接口前缀：

- `http://127.0.0.1:5000/api`

如果你在本地改成了其他端口，例如 `5002`，前端 `.env.local` 里的代理地址也要同步修改。

### 5. 启动前端

管理员端：

```bash
cd frontend\admin
npm install --legacy-peer-deps
npm run dev
```

用户端：

```bash
cd frontend\home
npm install --legacy-peer-deps
npm run dev
```

默认访问地址：

- 管理员端：`http://127.0.0.1:8080`
- 用户端：`http://127.0.0.1:8081`

## 文档

- [另一台电脑用 IDEA 部署](docs/DEPLOY_WITH_IDEA.md)
- [发布到 GitHub](docs/PUBLISH_TO_GITHUB.md)

## 开源发布提醒

这个项目目前没有附带开源许可证。如果你准备公开发布，建议先补一个你确认接受的许可证，例如：

- MIT
- Apache-2.0

许可证属于法律层面的授权承诺，不建议在你未明确选择前默认替你添加。
