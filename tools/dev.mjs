// tools/dev.mjs
import { spawn } from "node:child_process";
import { existsSync, cpSync } from "node:fs";
import { resolve } from "node:path";
import chalk from "chalk";

const isWin = process.platform === "win32";

// --- Paths ---
const apiDir = resolve("apps/api");
const appDir = resolve("apps/app");

// --- Config ---
const API_PORT = 3000;
const WEB_PORT = 5173;
const CLIENT_ORIGIN = `http://localhost:${WEB_PORT}`;

// --- .env ---
const envExample = resolve(apiDir, ".env.example");
const envFile = resolve(apiDir, ".env");
if (!existsSync(envFile) && existsSync(envExample)) {
  cpSync(envExample, envFile);
  console.log(chalk.yellow("[setup] Copied apps/api/.env"));
}

function run(name, color, cmd, args = [], opts = {}) {
  const prefix = chalk[color](`[${name}]`);

  const child = spawn(cmd, args, {
    shell: isWin,
    stdio: opts.stdio ?? ["ignore", "pipe", "pipe"],
    ...opts,
  });

  if (child.stdout && opts.stdio !== "inherit") {
    child.stdout.on("data", (d) => {
      process.stdout.write(`${prefix} ${d}`);
    });
  }

  if (child.stderr && opts.stdio !== "inherit") {
    child.stderr.on("data", (d) => {
      process.stderr.write(`${prefix} ${chalk.red(d)}`);
    });
  }

  child.on("error", (err) => {
    console.error(`${prefix} ${chalk.red(`spawn error: ${err.message}`)}`);
  });

  child.on("close", (code) => {
    console.log(`${prefix} ${chalk.red(`exit code ${code}`)}`);
  });

  return child;
}

// --- Backend (NestJS) ---
const apiEnv = {
  ...process.env,
  PORT: String(API_PORT),
  CLIENT_ORIGIN,
};

const api = run(
  "API",
  "green",
  "pnpm",
  ["start:dev"],
  {
    cwd: apiDir,
    env: apiEnv,
  }
);

// --- TSC Watcher ( TS -> JS ) ---
const tsc = run(
  "TSC",
  "yellow",
  "npx",
  ["tsc", "--watch", "--preserveWatchOutput"],
  {
    cwd: apiDir,
  }
);

// --- Frontend (Flutter Web) ---
console.log(chalk.cyan("[WEB] Starting Flutter…"));

const flutterArgs = [
  "run",
  "-d",
  "chrome",
  "--web-port",
  String(WEB_PORT),
  `--dart-define=API_BASE_URL=http://localhost:${API_PORT}`,
];

const web = run("APP", "cyan", "flutter", flutterArgs, {
  cwd: appDir,
  stdio: "inherit",
});

// --- Graceful shutdown ---
function shutdown() {
  console.log(chalk.redBright("\n🛑 Shutting down…"));
  try {
    api.kill();
  } catch {}
  try {
    tsc.kill();
  } catch {}
  try {
    web.kill();
  } catch {}
  process.exit(0);
}

process.on("SIGINT", shutdown);
process.on("SIGTERM", shutdown);

// --- Info banner ---
console.log(
  chalk.bold.greenBright(`
🚀 Dev started!

${chalk.green("API:")}  http://localhost:${API_PORT}
${chalk.cyan("WEB:")}  http://localhost:${WEB_PORT}

Flutter hotkeys:
 - ${chalk.cyan("r")}  hot reload
 - ${chalk.cyan("R")}  hot restart
 - Ctrl+C stop all
`)
);
