export default {
  '**/*.{ts,tsx,js,json,md,yml,yaml}': [
    'eslint --fix',
    'prettier --write',
  ],
};