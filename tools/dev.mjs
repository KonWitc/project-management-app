// tools/dev.mjs
import { spawn } from "node:child_process";
import { existsSync, cpSync, mkdirSync } from "node:fs";
import { resolve } from "node:path";
import chokidar from "chokidar";

const root = resolve(".");
const apiDir = resolve("apps/api");
const appDir = resolve("apps/app");

// ---- CONFIG DEV ----
const API_PORT = 3000; // Backend: http://localhost:3000
const WEB_PORT = 5173; // Flutter web: http://localhost:5173
const CLIENT_ORIGIN = `http://localhost:${WEB_PORT}`;

// .env for API – copy from .env.example if empty
const envExample = resolve(apiDir, ".env.example");
const envFile = resolve(apiDir, ".env");
if (!existsSync(envFile) && existsSync(envExample)) {
  cpSync(envExample, envFile);
  console.log("[setup] Copied apps/api/.env from .env.example");
}

// ensure tools dir
mkdirSync(resolve(root, "tools"), { recursive: true });

// --- Helper for logs ---
function run(name, cmd, args, opts = {}) {
  const child = spawn(cmd, args, {
    stdio: "pipe",
    shell: process.platform === "win32",
    ...opts,
  });
  child.stdout.on("data", (d) => process.stdout.write(`[${name}] ${d}`));
  child.stderr.on("data", (d) => process.stderr.write(`[${name}] ${d}`));
  child.on("close", (code) => console.log(`[${name}] exited with ${code}`));
  return child;
}

// --- Helper with stdin (for Flutter hot reload) ---
function runWithStdin(name, cmd, args, opts = {}) {
  const child = spawn(cmd, args, {
    stdio: ["pipe", "pipe", "pipe"],
    shell: process.platform === "win32",
    ...opts,
  });
  child.stdout.on("data", (d) => process.stdout.write(`[${name}] ${d}`));
  child.stderr.on("data", (d) => process.stderr.write(`[${name}] ${d}`));
  child.on("close", (code) => console.log(`[${name}] exited with ${code}`));
  return child;
}

// --- BACKEND (NestJS) ---
const apiEnv = {
  ...process.env,
  PORT: String(API_PORT),
  CLIENT_ORIGIN: CLIENT_ORIGIN,
};
const api = run(
  "API",
  process.platform === "win32" ? "powershell" : "bash",
  [
    process.platform === "win32"
      ? `cd "${apiDir}" ; pnpm i ; pnpm start:dev`
      : `cd "${apiDir}" && pnpm i && pnpm start:dev`,
  ],
  { env: apiEnv }
);

// --- TypeScript watcher ---
const tsc = run(
  "TSC",
  process.platform === "win32" ? "powershell" : "bash",
  [
    process.platform === "win32"
      ? `cd "${apiDir}" ; npx tsc --watch --preserveWatchOutput`
      : `cd "${apiDir}" && npx tsc --watch --preserveWatchOutput`,
  ]
);

// --- FRONTEND (Flutter web) ---
const app = runWithStdin(
  "WEB",
  process.platform === "win32" ? "powershell" : "bash",
  [
    process.platform === "win32"
      ? `cd "${appDir}" ; dart pub get ; flutter run -d chrome --web-port ${WEB_PORT} --dart-define=API_BASE=http://localhost:${API_PORT}`
      : `cd "${appDir}" && dart pub get && flutter run -d chrome --web-port ${WEB_PORT} --dart-define=API_BASE=http://localhost:${API_PORT}`,
  ]
);

// --- Hot reload watcher for Flutter ---
let reloadTimer = null;
function triggerHotReload() {
  if (!app?.stdin) return;
  if (reloadTimer) clearTimeout(reloadTimer);
  reloadTimer = setTimeout(() => {
    try {
      app.stdin.write("r\n"); // Flutter hot reload
      console.log("[WATCH] 🔁 Hot reload triggered");
    } catch (e) {
      console.error("[WATCH] Hot reload failed:", e.message);
    }
  }, 150);
}

const webWatch = chokidar
  .watch(`${appDir}/lib/**/*.dart`, { ignoreInitial: true })
  .on("add", triggerHotReload)
  .on("change", triggerHotReload)
  .on("unlink", triggerHotReload);

// --- graceful shutdown ---
function shutdown() {
  console.log("\n🛑 Shutting down...");
  try {
    webWatch?.close();
  } catch {}
  try {
    api.kill();
    tsc.kill();
    app.kill();
  } catch {}
  process.exit(0);
}
process.on("SIGINT", shutdown);
process.on("SIGTERM", shutdown);

console.log(
  `\n🚀 Dev start:\n- API:  http://localhost:${API_PORT}\n- WEB:  http://localhost:${WEB_PORT}\n`
);
