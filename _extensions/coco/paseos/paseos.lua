-- Photo carousel for paseo posts.
--
--   {{< carousel >}}   slider built from the `carousel:` list in the YAML header
--
-- Photo names are resolved against `images/` and default to `.jpg`, so a post
-- only ever writes `foto-1` instead of `images/foto-1.jpg`.

local FOLDER = "images"
local EXTENSION = ".jpg"

local count = 0

local function escape(text)
  text = text:gsub("&", "&amp;")
  text = text:gsub("<", "&lt;")
  text = text:gsub(">", "&gt;")
  text = text:gsub('"', "&quot;")
  return text
end

-- `foto-1` becomes `images/foto-1.jpg`; a name that already carries a folder
-- or an extension is left as written.
local function path_for(name)
  if not name:find("%.%w+$") then
    name = name .. EXTENSION
  end
  if not name:find("/") then
    name = FOLDER .. "/" .. name
  end
  return escape(name)
end

-- Every entry of `carousel:` is one `photo: caption` pair.
local function read_slides(meta)
  local slides = {}
  if not meta.carousel then
    return slides
  end
  for _, entry in ipairs(meta.carousel) do
    for name, caption in pairs(entry) do
      slides[#slides + 1] = {
        src = path_for(name),
        caption = escape(pandoc.utils.stringify(caption)),
      }
    end
  end
  return slides
end

-- The caption sits below the photo rather than over it, so it stays readable
-- and has room to run long.
local function slide_html(slide, first)
  local html = ('<div class="carousel-item%s"><img src="%s" class="d-block w-100">')
    :format(first and " active" or "", slide.src)
  if slide.caption ~= "" then
    html = html .. ('<p class="paseo-caption">%s</p>'):format(slide.caption)
  end
  return html .. "</div>"
end

local function carousel(args, kwargs, meta)
  local slides = read_slides(meta)
  if #slides == 0 then
    return pandoc.RawBlock("html", "")
  end

  count = count + 1
  local id = "carousel-" .. count

  local items = {}
  for i, slide in ipairs(slides) do
    items[i] = slide_html(slide, i == 1)
  end

  return pandoc.RawBlock("html", ([[
<div id="%s" class="carousel slide" data-bs-ride="carousel">
  <div class="carousel-inner">%s</div>
  <button class="carousel-control-prev" type="button" data-bs-target="#%s" data-bs-slide="prev">
    <span class="carousel-control-prev-icon"></span>
  </button>
  <button class="carousel-control-next" type="button" data-bs-target="#%s" data-bs-slide="next">
    <span class="carousel-control-next-icon"></span>
  </button>
</div>]]):format(id, table.concat(items), id, id))
end

return {
  carousel = carousel,
}
