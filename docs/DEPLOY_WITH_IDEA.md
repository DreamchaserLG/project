# IDEA 部署说明

## 适用场景

适用于另一台 Windows 电脑，从 GitHub 拉取本项目后，使用 IntelliJ IDEA 部署和运行。

## 需要安装的软件

1. Git
2. IntelliJ IDEA
3. JDK 8
4. Maven 3.6.1 及以上
5. MySQL 8.0 或 5.7
6. Redis 6.x 或兼容版本
7. Node.js 22.17.0
8. npm 10.9.2

## IDEA 配置建议

### JDK

- `File -> Project Structure -> Project`
- `Project SDK` 选择 `1.8`
- `Project language level` 选择和 JDK 8 对应的级别

### Maven

- `Settings -> Build, Execution, Deployment -> Build Tools -> Maven`
- `Maven home path` 选择你本机安装的 Maven
- `User settings file` 使用默认 `${user.home}\\.m2\\settings.xml`，或者你自己的自定义 settings

本仓库不会提交作者本机的 `maven/conf/settings.xml`，这是刻意做的隐私隔离。

## 部署步骤

### 1. 拉取项目

```bash
git clone <your-github-repo-url>
cd project
```

### 2. 导入数据库

先创建数据库：

```sql
CREATE DATABASE project_db DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

再按顺序导入：

```bash
mysql -u root -p project_db < sql/project.sql
mysql -u root -p project_db < sql/project_patch_local.sql
mysql -u root -p project_db < sql/refresh_demo_content.sql
mysql -u root -p project_db < sql/waitlist_demo.sql
```

### 3. 配置后端

复制：

```bash
copy src\main\resources\application-local.example.yml src\main\resources\application-local.yml
```

然后填写：

- `spring.datasource.url`
- `spring.datasource.username`
- `spring.datasource.password`
- `spring.redis.host`
- `spring.redis.port`
- `spring.redis.password`
- `spring.mail.username`
- `spring.mail.password`
- `app.mail.from`

如果你不测试邮箱验证码，邮箱部分可以先留空。

### 4. 配置前端

复制：

```bash
copy frontend\admin\.env.example frontend\admin\.env.local
copy frontend\home\.env.example frontend\home\.env.local
```

确认：

- `VUE_APP_DEV_PROXY_TARGET` 指向后端地址，例如 `http://127.0.0.1:5000`

如果你需要地图功能，再填写：

- `VUE_APP_AMAP_JS_KEY`
- `VUE_APP_AMAP_WEB_KEY`
- `VUE_APP_AMAP_SECURITY_CODE`

### 5. 启动后端

在 IDEA 中运行：

- Main class：`com.project.demo.Application`
- Environment variables：`SPRING_PROFILES_ACTIVE=local`
- Working directory：项目根目录

### 6. 启动前端

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

## 常见问题

### 1. 登录失败

先确认：

- 后端是否已启动
- MySQL 配置是否正确
- Redis 密码是否正确
- 前端代理地址是否和后端端口一致

### 2. Maven 下载慢

建议你在自己的 Maven `settings.xml` 里配置镜像，而不是把某一台电脑的本地仓库路径直接写进项目。

### 3. npm install 报依赖冲突

本项目前端建议使用：

- Node.js `22.17.0`
- npm `10.9.2`

并在安装时使用：

```bash
npm.cmd install --legacy-peer-deps
```
