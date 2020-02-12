FROM node:12.14-alpine

EXPOSE 3000

RUN apk add --no-cache tini

#RUN groupadd --gid 1000 node \
#    && useradd --uid 1000 --gid node --shell /bin/bash --create-home node

COPY . ./nest

RUN chown -R node:node ./nest

WORKDIR /nest

#USER node

RUN npm i && npm run build && npm cache clean --force 

WORKDIR /nest/dist

ENTRYPOINT [ "/sbin/tini", "--" ]

CMD ["node", "main.js"]