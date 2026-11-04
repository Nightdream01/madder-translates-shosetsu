# Madder Translates — Shosetsu repository

A standalone Shosetsu source extension for Madder Translates.

## Included source

- **Hero of the Rebellion ~A Cliché Otherworld Summoning And Reverse-Transportation To Japan~**
- Novel listing: `https://maddertranslates.com/wn08/`
- Chapter list is read from the publisher's live table of contents.
- Chapter text is fetched from the original chapter pages inside Shosetsu.

## Install

1. Create a public GitHub repository and upload the contents of this folder (keep `index.json` at the repository root).
2. In Shosetsu, open **More → Repositories → +**.
3. Repository name: `Madder Translates`
4. Repository URL: `https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/YOUR_REPOSITORY/main/`
5. Save, refresh repositories, then install **Madder Translates** from Browse.

To verify the repository URL, open the URL with `index.json` appended. It should display the JSON catalogue.

## Notes

- This is an independent, community-made extension, not an official Shosetsu or Madder Translates product.
- Chapter text remains hosted by Madder Translates. The extension fetches it for reading; it does not bundle or redistribute chapter text.
- The source page and WordPress theme may change. If chapter parsing stops working, update the selectors in `src/en/MadderTranslates.lua`.
- The extension has not been run through Shosetsu's official extension tester in this environment. Test it in the app after adding the repository.
