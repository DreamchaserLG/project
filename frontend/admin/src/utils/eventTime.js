const EVENT_TIME_PATTERN = /\d{4}-\d{2}-\d{2}[ T]\d{2}:\d{2}(?::\d{2})?/g;

function pad(value) {
  return String(value).padStart(2, "0");
}

export function parseEventDateTime(value) {
  if (!value) {
    return null;
  }
  const match = String(value).trim().match(
    /^(\d{4})-(\d{2})-(\d{2})[ T](\d{2}):(\d{2})(?::(\d{2}))?$/
  );
  if (!match) {
    return null;
  }
  const date = new Date(
    Number(match[1]),
    Number(match[2]) - 1,
    Number(match[3]),
    Number(match[4]),
    Number(match[5]),
    Number(match[6] || 0)
  );
  return Number.isNaN(date.getTime()) ? null : date;
}

export function formatEventDateTime(value, withSeconds = true) {
  const date = value instanceof Date ? value : parseEventDateTime(value);
  if (!date) {
    return "";
  }
  const base = `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())} ${pad(date.getHours())}:${pad(date.getMinutes())}`;
  return withSeconds ? `${base}:${pad(date.getSeconds())}` : base;
}

export function parseEventTimeRange(value) {
  if (!value) {
    return [];
  }
  const matches = String(value).match(EVENT_TIME_PATTERN);
  if (!matches || matches.length < 2) {
    return [];
  }
  return matches.slice(0, 2).map((item) => formatEventDateTime(item.replace("T", " "), true));
}

export function formatEventTimeRange(range, withSeconds = true) {
  if (!Array.isArray(range) || range.length !== 2) {
    return "";
  }
  const start = formatEventDateTime(range[0], withSeconds);
  const end = formatEventDateTime(range[1], withSeconds);
  return start && end ? `${start} 至 ${end}` : "";
}

export function formatEventTimeForDisplay(value, mode = "range") {
  const range = parseEventTimeRange(value);
  if (!range.length) {
    return value || "时间待更新";
  }
  if (mode === "date") {
    return `${range[0].slice(0, 10)} 至 ${range[1].slice(0, 10)}`;
  }
  if (mode === "minute") {
    return formatEventTimeRange(range, false);
  }
  return formatEventTimeRange(range, true);
}
