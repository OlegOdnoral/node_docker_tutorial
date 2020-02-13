# Production stage
FROM node:lts-alpine as prod

#ENV NODE_ENV=production

EXPOSE 3000

RUN apk add --no-cache tini

COPY . ./nest

WORKDIR /nest/

RUN npm i --silent && npm run build --silent && npm cache clean --force --silent

#RUN chown -R node:node .

ENTRYPOINT [ "/sbin/tini", "--" ]

CMD ["node", "./dist/main.js"]

# Development stage
FROM prod as dev

#ENV NODE_ENV=development

CMD ["npm", "run" , "start:dev", "--silent"]

# Testing stage
FROM dev as test

#ENV NODE_ENV=testing

CMD ["npm", "run", "test", "--silent"]
