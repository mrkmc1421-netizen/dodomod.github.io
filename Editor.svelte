<script lang="ts">
  import Sprite1 from "./Sprite1.svelte";

  let sprites = [];
  sprites.push({
    id: "sprite1",
    name: "Dodo",
    x: 200,
    y: 200,
    currentCostume: 0,
    costumes: [
      {
        id: "dodo-default",
        name: "Dodo Mascot",
        url: "/assets/dodo.png"
      }
    ]
  });
</script>

{#each sprites as s}
  <Sprite1 sprite={s} />
{/each}
