import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { INestApplication } from '@nestjs/common';

function terminationHandler(app: INestApplication) {
  const shutdown = function () {
    app.close().then(
      () => {
        process.exit();
      },
      (error) => {
        console.error(error);
        process.exitCode = 1;
      }
    );
  }
  process.on('SIGINT', function onSigint () {
    console.info('Got SIGINT (aka ctrl-c in docker). Graceful shutdown ', new Date().toISOString());
    shutdown();
  });
  process.on('SIGTERM', function onSigterm () {
    console.info('Got SIGTERM (docker container stop). Graceful shutdown ', new Date().toISOString());
    shutdown();
  });
}

async function bootstrap() {
  const app: INestApplication = await NestFactory.create(AppModule);
  terminationHandler(app);
  await app.listen(3000);
}
bootstrap();
