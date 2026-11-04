-- {"id":8842107,"ver":"1.0.3","libVer":"1.0.0","author":"Community","repo":"","dep":[]}
-- Madder Translates source for Shosetsu.
-- This extension indexes the novel page and reads chapters from the publisher's site.

local id = 8842107
local name = "Madder Translates"
local baseURL = "https://maddertranslates.com"
local novelURL = "/wn08/"

local function trim(value)
    if value == nil then return nil end
    return (value:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function absoluteURL(url)
    if url == nil or url == "" then return nil end
    if url:match("^https?://") then return url end
    if url:sub(1, 1) == "/" then return baseURL .. url end
    return baseURL .. "/" .. url
end

local function shrinkURL(url, _type)
    if url == nil then return "" end
    return (url:gsub("^https?://maddertranslates%.com", ""))
end

local function expandURL(url, _type)
    return absoluteURL(url)
end

local function parseChapterLinks(document)
    local found = {}
    local seen = {}
    local links = document:select('a[href*="/wn08/c"]')

    map(links, function(anchor)
        local href = anchor:attr("href")
        local title = trim(anchor:text())
        if href and title and title ~= "" then
            local full = absoluteURL(href)
            if full and not seen[full] then
                seen[full] = true
                local number = title:match("^%s*(%d+)")
                found[#found + 1] = {
                    title = title,
                    url = shrinkURL(full),
                    number = tonumber(number) or (#found + 1)
                }
            end
        end
    end)

    table.sort(found, function(a, b) return a.number < b.number end)
    return found
end

local function getListing(_data)
    local document = GETDocument(absoluteURL(novelURL))
    return {
        Novel {
            title = "Hero of the Rebellion ~A Cliché Otherworld Summoning And Reverse-Transportation To Japan~",
            link = novelURL,
            imageURL = ""
        }
    }
end

local function parseNovel(_novelURL, loadChapters)
    local document = GETDocument(absoluteURL(novelURL))
    local titleElement = document:selectFirst("h1")
    local title = titleElement and trim(titleElement:text())
        or "Hero of the Rebellion ~A Cliché Otherworld Summoning And Reverse-Transportation To Japan~"

    local info = NovelInfo {
        title = title,
        imageURL = "",
        description = "English translation hosted by Madder Translates. Original work: 反逆の勇者　〜テンプレクソ異世界召喚と日本逆転送〜",
        authors = { "川崎悠" },
        genres = { "Isekai", "Fantasy", "Action" },
        tags = { "Madder Translates" },
        status = NovelStatus.PUBLISHING
    }

    if loadChapters then
        local chapters = {}
        local parsed = parseChapterLinks(document)
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

local function getPassage(chapterURL)
    local url = expandURL(chapterURL)
    local document = GETDocument(url)

    -- Return the fetched page body directly. Madder Translates' chapter text
    -- is present in the page, but its theme container is not reliably matched
    -- by generic WordPress selectors in Shosetsu's HTML parser.
    local body = document:selectFirst("body")
    if body == nil then
        error("Madder Translates: chapter page has no body element: " .. url)
    end

    return pageOfElem(body, false)
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
        Listing("Hero of the Rebellion", false, getListing)
    },
    shrinkURL = shrinkURL,
    expandURL = expandURL,
    parseNovel = parseNovel,
    getPassage = getPassage
}
