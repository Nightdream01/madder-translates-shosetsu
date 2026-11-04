-- {"id":8842107,"ver":"1.0.9","libVer":"1.0.0","author":"Community","repo":"","dep":[]}
-- Madder Translates source for Shosetsu.
-- Discovers every series on the site's Web Novel index.

local id = 8842107
local name = "Madder Translates"
local baseURL = "https://maddertranslates.com"
local webNovelURL = "/wn/"

local function trim(value)
    if value == nil then return nil end
    return (value:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function absoluteURL(url)
    if url == nil or url == "" then return nil end
    if url:match("^https?://") then
        return (url:gsub("^https?://www%.maddertranslates%.com", baseURL))
    end
    if url:sub(1, 1) == "/" then return baseURL .. url end
    return baseURL .. "/" .. url
end

local function shrinkURL(url, _type)
    if url == nil then return "" end
    url = url:gsub("^https?://www%.maddertranslates%.com", baseURL)
    return (url:gsub("^https?://maddertranslates%.com", ""))
end

local function expandURL(url, _type)
    return absoluteURL(url)
end

local function novelPath(url)
    local path = shrinkURL(url)
    path = path:gsub("/+$", "")
    return path
end

local function parseNovelLinks(document)
    local found = {}
    local seen = {}
    local links = document:select("a[href]")

    map(links, function(anchor)
        local href = anchor:attr("href")
        local title = trim(anchor:text())
        if href and title and title ~= "" then
            local full = absoluteURL(href)
            local path = full and shrinkURL(full)
            if path and path:match("^/wn%d+/?$") and not seen[path] then
                seen[path] = true
                title = title:gsub("^・%s*", "")
                found[#found + 1] = Novel {
                    title = title,
                    link = path,
                    imageURL = ""
                }
            end
        end
    end)

    return found
end

local function parseChapterLinks(document, seriesURL)
    local found = {}
    local seen = {}
    local prefix = novelPath(seriesURL) .. "/c"
    local links = document:select("a[href]")

    map(links, function(anchor)
        local href = anchor:attr("href")
        local title = trim(anchor:text())
        if href and title and title ~= "" then
            local full = absoluteURL(href)
            local path = full and shrinkURL(full)
            if path and path:sub(1, #prefix) == prefix and not seen[path] then
                seen[path] = true
                found[#found + 1] = {
                    title = title,
                    url = path
                }
            end
        end
    end)

    return found
end

local function getListing(_data)
    local document = GETDocument(absoluteURL(webNovelURL))
    return parseNovelLinks(document)
end

local function parseNovel(seriesURL, loadChapters)
    local url = absoluteURL(seriesURL)
    local document = GETDocument(url)
    local titleElement = document:selectFirst("h1")
    local title = titleElement and trim(titleElement:text()) or "Madder Translates novel"

    local description = ""
    local content = document:selectFirst(".td-page-content")
    if content then
        local firstParagraph = content:selectFirst("p")
        if firstParagraph then
            description = trim(firstParagraph:text()) or ""
        end
    end

    local info = NovelInfo {
        title = title,
        imageURL = "",
        description = description,
        tags = { "Madder Translates" },
        status = NovelStatus.PUBLISHING
    }

    if loadChapters then
        local chapters = {}
        local parsed = parseChapterLinks(document, url)
        for i, chapter in ipairs(parsed) do
            chapters[#chapters + 1] = NovelChapter {
                order = i,
                title = chapter.title,
                link = chapter.url
            }
        end
        info:setChapters(AsList(chapters))
    end

    return info
end

local function parseChapterPage(chapterURL)
    local url = expandURL(chapterURL)
    local document = GETDocument(url)
    local content = document:selectFirst(".td-page-content")

    if content == nil then
        error("Madder Translates: could not locate .td-page-content at " .. url)
    end

    -- Remove the current series' NEXT/TOC navigation and site-wide promo/ad blocks.
    local seriesPath = url:match("(/wn%d+)/c")
    if seriesPath then
        content:select("p:has(a[href*='" .. seriesPath .. "/c'])"):remove()
    end
    content:select(".code-block, script, style, iframe, ins, .adsbygoogle"):remove()

    return content
end

local function getPassage(chapterURL)
    return pageOfElem(parseChapterPage(chapterURL))
end

return {
    id = id,
    name = name,
    baseURL = baseURL,
    imageURL = "https://maddertranslates.com/favicon.ico",
    chapterType = ChapterType.HTML,
    hasCloudFlare = false,
    hasSearch = false,
    isSearchIncrementing = false,
    startIndex = 1,
    listings = {
        Listing("Web Novels", false, getListing)
    },
    shrinkURL = shrinkURL,
    expandURL = expandURL,
    parseNovel = parseNovel,
    getPassage = getPassage
}
