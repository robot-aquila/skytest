<?php

use DI\Container;
use DI\ContainerBuilder;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

require(dirname(__FILE__) . '/../config.php');
require(dirname(__FILE__) . '/../../vendor/autoload.php');

$cb = new ContainerBuilder();
$cb->addDefinitions([
    PDO::class => function() {
        $dbh = new PDO('mysql:host=' . REST_HOSTNAME . ';dbname=' . REST_DATABASE, REST_USERNAME, REST_PASSWORD);
        $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $dbh->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
        return $dbh;
    }
]);
$container = $cb->build();

$app = DI\Bridge\Slim\Bridge::create($container);
$app->addRoutingMiddleware();
$app->addErrorMiddleware(true, true, true);
$app->get('/profile/{id}', [\Sky\ProfileController::class, 'get']);
$app->put('/profile', [\Sky\ProfileController::class, 'put']);
$app->delete('/profile/{id}', [\Sky\ProfileController::class, 'delete']);
$app->run();
