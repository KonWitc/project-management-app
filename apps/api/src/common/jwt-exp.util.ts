export function parseExpires(
  input: string | undefined,
  fallback: number | string,
): number | string {
  if (!input) return fallback;
  const v = input.trim();
  if (/^\d+$/.test(v)) return Number(v); // "900" -> 900
  if (/^\d+\s*[smhd]$/i.test(v)) return v.replace(/\s+/g, ""); // "15 m" -> "15m"
  throw new Error(
    "Invalid JWT expires format. Use seconds (e.g. 900) or smhd (e.g. 15m, 12h, 7d).",
  );
}
