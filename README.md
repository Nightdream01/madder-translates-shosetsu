# Madder Translates — Shosetsu repository

A standalone Shosetsu source extension for Madder Translates.

## Included source

The extension discovers series automatically from the site's **Web Novel** index:

- The Reincarnated Boy’s Growth Log
- We Are Not Dating『Yet』!!
- If I Had To Say, I Would Say I Am A Evil Magician
- Hero Of The Rebellion
- A Reincarnated God’s Bride Search
- The Boy Who Swore Revenge On The World (hiatus)

New series added to the Web Novel index can be picked up automatically, provided they use the same site URL and page structure.

Chapter lists are read from each novel's own table of contents. Chapter text is extracted from the Newsmag page-content container, with navigation, promotional blocks, and ads removed.

## Install

1. In Shosetsu, open **More → Repositories → +**
2. Repository name: `Madder Translates`
3. Repository URL: `https://raw.githubusercontent.com/Nightdream01/madder-translates-shosetsu/main/`
4. Save, refresh repositories, then install **Madder Translates** from Browse.

To verify the repository URL, open the URL with `index.json` appended. It should display the JSON catalogue.

## Notes

- This is an independent, community-made extension, not an official Shosetsu or Madder Translates product.
- Chapter text remains hosted by Madder Translates. The extension fetches it for reading; it does not bundle or redistribute chapter text.
- The source has not been run through Shosetsu's official extension tester in this environment. Test it in the app after refreshing the repository.
