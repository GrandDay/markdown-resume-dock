import { defineNuxtConfig } from "nuxt/config";
import { createPwaConfig } from "./configs/pwa";
import { i18n } from "./configs/i18n";

const normalizeBase = (value?: string): string => {
  if (!value) return "/";
  const prefixed = value[0] === "/" ? value : `/${value}`;
  const hasTrailingSlash = prefixed[prefixed.length - 1] === "/" ? prefixed : `${prefixed}/`;
  return hasTrailingSlash;
};

const runtimeEnv = (globalThis as { process?: { env?: Record<string, string | undefined> } }).process?.env ?? {};

const rawBaseURL = runtimeEnv.NUXT_PUBLIC_BASE_URL || "/";
const baseURL = normalizeBase(rawBaseURL);
const siteUrl = runtimeEnv.NUXT_PUBLIC_SITE_URL || "http://localhost:3000";
const canonicalUrl = `${siteUrl.replace(/\/$/, "")}${baseURL}`;
const siteName = runtimeEnv.NUXT_PUBLIC_SITE_NAME || "Markdown Resume";
const googleFontsKey = runtimeEnv.NUXT_PUBLIC_GOOGLE_FONTS_KEY || "";

// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  srcDir: "src/",

  modules: [
    "@vueuse/nuxt",
    "@unocss/nuxt",
    "@pinia/nuxt",
    "@nuxtjs/i18n",
    "@nuxtjs/color-mode",
    "@vite-pwa/nuxt",
    "nuxt-simple-sitemap"
  ],

  css: [
    "@unocss/reset/tailwind.css",
    "katex/dist/katex.min.css",
    "~/assets/css/index.css"
  ],

  components: [
    {
      path: "~/components",
      pathPrefix: false
    }
  ],

  i18n,

  runtimeConfig: {
    public: {
      googleFontsKey
    }
  },

  colorMode: {
    preference: "light",
    classSuffix: ""
  },

  app: {
    baseURL,
    buildAssetsDir: "assets", // don't use "_" at the begining of the folder name to avoids
    head: {
      viewport: "width=device-width,initial-scale=1",
      link: [
        { rel: "apple-touch-icon", href: "/apple-touch-icon.png" },
        { rel: "mask-icon", href: "/safari-pinned-tab.svg", color: "#222" }
      ],
      meta: [
        { name: "viewport", content: "width=device-width, initial-scale=1" },
        { name: "application-name", content: "Markdown Resume" },
        { name: "apple-mobile-web-app-title", content: "Markdown Resume" },
        { name: "msapplication-TileColor", content: "#fff" },
        { property: "og:url", content: canonicalUrl },
        { property: "og:type", content: "website" }
      ]
    }
  },

  site: {
    url: siteUrl,
    name: siteName,
  },

  pwa: createPwaConfig(baseURL),

});
