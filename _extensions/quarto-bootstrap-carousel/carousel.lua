local stringify = pandoc.utils.stringify

-- CSS injected once per document
local injected_style = [[
<style>
.carousel-control-prev,
.carousel-control-next {
  opacity: 1 !important;
  visibility: visible !important;
  transition: opacity 0.2s ease;
}

.carousel-control-prev-icon,
.carousel-control-next-icon {
  background-size: 3rem 3rem;
  filter: drop-shadow(0 0 5px black);
}
</style>
]]

local style_injected = false

-- Helper: Convert RawBlocks to HTML strings
local function blocks_to_html(blocks)
  local html = {}
  for _, block in ipairs(blocks) do
    table.insert(html, pandoc.write(pandoc.Pandoc({block}), "html"))
  end
  return table.concat(html, "\n")
end

function Div(el)
  if not el.classes:includes("carousel") then
    return nil
  end

  local carousel_id = "carousel-" .. pandoc.utils.sha1(stringify(el))
  local indicators = {}
  local items = {}
  local slide_index = 0

  -- Loop through content and find images
  for _, block in ipairs(el.content) do
    if block.t == "Para" then
      for _, inline in ipairs(block.content) do
        if inline.t == "Image" then
          inline.attributes.class = "d-block w-100"

          local is_active = (slide_index == 0) and "active" or ""

          -- Get per-image caption from fig-caption or alt text
          local caption = inline.attributes["fig-caption"] or stringify(inline.caption)
          local caption_html = caption and string.format('<div class="carousel-caption d-none d-md-block"><p>%s</p></div>', caption) or ""

          -- Indicator button
          table.insert(indicators, pandoc.RawBlock("html", string.format([[
            <button type="button" data-bs-target="#%s" data-bs-slide-to="%d" class="%s" aria-label="Slide %d"></button>
          ]], carousel_id, slide_index, is_active, slide_index + 1)))

          -- Carousel item
          local img_html = pandoc.write(pandoc.Pandoc({pandoc.Para({inline})}), "html")
          local item_html = string.format('<div class="carousel-item %s">%s%s</div>', is_active, img_html, caption_html)

          table.insert(items, pandoc.RawBlock("html", item_html))

          slide_index = slide_index + 1
        end
      end
    end
  end

  if slide_index == 0 then
    return nil
  end

  -- Core carousel HTML
  local carousel_html = string.format([[
<div id="%s" class="carousel slide" data-bs-ride="false">
  <div class="carousel-indicators">
    %s
  </div>
  <div class="carousel-inner">
    %s
  </div>
  <button class="carousel-control-prev" type="button" data-bs-target="#%s" data-bs-slide="prev">
    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
    <span class="visually-hidden">Previous</span>
  </button>
  <button class="carousel-control-next" type="button" data-bs-target="#%s" data-bs-slide="next">
    <span class="carousel-control-next-icon" aria-hidden="true"></span>
    <span class="visually-hidden">Next</span>
  </button>
</div>
]],
    carousel_id,
    blocks_to_html(indicators),
    blocks_to_html(items),
    carousel_id,
    carousel_id
  )

  -- Optional overall caption
  local overall_caption = el.attributes["data-caption"]
  if overall_caption then
    carousel_html = string.format([[
<figure>
  %s
  <figcaption class="mt-2 text-center">%s</figcaption>
</figure>
]], carousel_html, pandoc.utils.stringify(overall_caption))
  end

  -- Inject style only once
  if not style_injected then
    style_injected = true
    return {
      pandoc.RawBlock("html", injected_style),
      pandoc.RawBlock("html", carousel_html)
    }
  else
    return pandoc.RawBlock("html", carousel_html)
  end
end
