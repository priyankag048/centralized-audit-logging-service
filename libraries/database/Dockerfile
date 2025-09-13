FROM node:24-alpine

WORKDIR /usr/app

RUN npm install -g pnpm

COPY package.json pnpm-lock.yaml ./

RUN pnpm install --frozen-lockfile

COPY . .

RUN pnpm build

CMD ["node", "src/index.ts"]