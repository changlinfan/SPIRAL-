const { PHASE_DEVELOPMENT_SERVER } = require('next/constants')
/** @type {import('next').NextConfig} */

module.exports = async (phase, { defaultConfig }) => {
  if (phase === PHASE_DEVELOPMENT_SERVER) return {}

  const nextConfig = {
    reactStrictMode: true,
    output: 'export',
    distDir: '../html',
  }

  return nextConfig
}