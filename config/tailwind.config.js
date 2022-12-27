const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  content: [
    "./public/*.html",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    "./app/views/**/*.{erb,haml,html,slim}",
  ],
  theme: {
    extend: {
      fontSize: {
        "2xs": ["9px", "9px"],
      },
      fontFamily: {
        // sans: ["Inter var", ...defaultTheme.fontFamily.sans],
        sans: ["Bai Jamjuree", "Arial", "sans-serif"],
        digital: ["pixeloid", "Arial", "sans-serif"],
        digitalbold: ["pixeloid-bold", "Arial", "sans-serif"],
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/aspect-ratio"),
    require("@tailwindcss/typography"),
  ],
};
