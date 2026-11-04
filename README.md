# Madder Translates

A Shosetsu extension for reading novels from [Madder Translates](https://maddertranslates.com/).

## Features

- **Automatic novel discovery:** Loads the novels listed in the site's Web Novel directory. Newly listed novels can appear automatically when they follow the site's existing URL and page structure.
- **Chapter lists:** Retrieves chapter links from each novel's table of contents.
- **Clean chapter text:** Extracts the chapter content and removes site navigation, promotional blocks, and advertisements.
- **Canonical URLs:** Handles both www and non-www versions of the site's URLs.

## Install

1. Open Shosetsu.
2. Go to **More → Repositories → +**.
3. Enter the repository URL:

   `https://raw.githubusercontent.com/Nightdream01/madder-translates-shosetsu/main/`

4. Save the repository and refresh the repository list.
5. Find **Madder Translates** under Browse and install it.

You can check that the repository is reachable by opening the URL above with `index.json` appended.

## Current version

**1.0.9**

The extension is being tested in Shosetsu. Novel discovery, chapter lists, and chapter extraction should be checked across different titles, since site layouts or URL patterns may vary.

## Notes

- This is an independent, community-made extension. It is not an official product of Shosetsu or Madder Translates.
- Chapter text is fetched from Madder Translates when you read it. The extension does not bundle chapter text.
- If a novel is missing or a chapter does not load correctly, please report the novel title and its Madder Translates URL in the repository's Issues section.
