<script lang="ts">
  export type Sprite = {
    id: string;
    name: string;
    costumes: { id: string; name: string; url: string }[];
    currentCostume: number;
    x: number;
    y: number;
  };

  // Dodo mascot as Sprite1
  export let sprite: Sprite = {
    id: "sprite1",
    name: "Dodo",
    x: 200,
    y: 200,
    currentCostume: 0,
    costumes: [
      {
        id: "dodo-default",
        name: "Dodo Mascot",
        url: "/assets/dodo.png" // place your dodo image here
      }
    ]
  };

  function switchCostume(index: number) {
    sprite.currentCostume = index;
  }
</script>

<style>
  .sprite {
    position: absolute;
    transform: translate(-50%, -50%);
    cursor: pointer;
  }
</style>

<div
  class="sprite"
  style="left: {sprite.x}px; top: {sprite.y}px;"
>
  <img
    src={sprite.costumes[sprite.currentCostume].url}
    alt={sprite.name}
    draggable="false"
  />
</div>
