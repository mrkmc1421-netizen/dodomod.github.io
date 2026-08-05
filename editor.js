const canvas = document.getElementById("editorCanvas");
const ctx = canvas.getContext("2d");

const loader = document.getElementById("blockLoader");
const loadBtn = document.getElementById("loadBlocksBtn");

let blocks = [];
let selectedBlock = null;
let dragOffsetX = 0;
let dragOffsetY = 0;

function drawBlocks() {
  ctx.clearRect(0, 0, canvas.width, canvas.height);

  for (const block of blocks) {
    ctx.fillStyle = block.color || "#4caf50";
    ctx.fillRect(block.x, block.y, block.width, block.height);

    ctx.strokeStyle = "#ffffff";
    ctx.lineWidth = block === selectedBlock ? 3 : 1;
    ctx.strokeRect(block.x, block.y, block.width, block.height);

    if (block.label) {
      ctx.fillStyle = "#ffffff";
      ctx.font = "12px sans-serif";
      ctx.fillText(block.label, block.x + 6, block.y + 16);
    }
  }
}

function loadBlocksFromJSON(jsonText) {
  try {
    const data = JSON.parse(jsonText);
    if (!Array.isArray(data)) {
      console.error("Block data must be an array.");
      return;
    }

    blocks = data.map(b => ({
      x: Number(b.x) || 0,
      y: Number(b.y) || 0,
      width: Number(b.width) || 80,
      height: Number(b.height) || 40,
      color: b.color || "#4caf50",
      label: b.label || ""
    }));

    selectedBlock = null;
    drawBlocks();
  } catch (e) {
    console.error("Invalid JSON:", e);
  }
}

function getBlockAt(x, y) {
  for (let i = blocks.length - 1; i >= 0; i--) {
    const b = blocks[i];
    if (
      x >= b.x &&
      x <= b.x + b.width &&
      y >= b.y &&
      y <= b.y + b.height
    ) {
      return b;
    }
  }
  return null;
}

canvas.addEventListener("mousedown", (e) => {
  const rect = canvas.getBoundingClientRect();
  const x = e.clientX - rect.left;
  const y = e.clientY - rect.top;

  const block = getBlockAt(x, y);
  selectedBlock = block;

  if (block) {
    dragOffsetX = x - block.x;
    dragOffsetY = y - block.y;
  }

  drawBlocks();
});

canvas.addEventListener("mousemove", (e) => {
  if (!selectedBlock) return;

  const rect = canvas.getBoundingClientRect();
  const x = e.clientX - rect.left;
  const y = e.clientY - rect.top;

  selectedBlock.x = x - dragOffsetX;
  selectedBlock.y = y - dragOffsetY;

  drawBlocks();
});

canvas.addEventListener("mouseup", () => {
  selectedBlock = null;
});

canvas.addEventListener("mouseleave", () => {
  selectedBlock = null;
});

loadBtn.addEventListener("click", () => {
  const text = loader.value.trim();
  if (!
