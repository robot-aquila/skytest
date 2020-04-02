<?php

namespace Sky;

use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Message\ResponseInterface as Response;

class ProfileController {
    private $db;

    public function __construct(\PDO $db) {
        $this->db = $db;
    }

    public function get($id, Request $request, Response $response): Response {
        $sth = $this->db->prepare('SELECT profile_id,name,age FROM profile WHERE profile_id=?');
        $sth->bindValue(1, $id);
        $sth->execute();
        $json = $sth->fetch(\PDO::FETCH_ASSOC);
        if ( $json === false ) {
            return $this->errorResponse($response, 404, 'Profile not found');
        } else {
            return $this->successResponse($response, $json);
        }
    }

    public function delete($id, Request $request, Response $response): Response {
        $sth = $this->db->prepare('DELETE FROM profile WHERE profile_id=?');
        $sth->bindValue(1, $id);
        $sth->execute();
        if ( $sth->rowCount() > 0 ) {
            return $this->successResponse($response, array('profile_id' => $id));
        } else {
            return $this->errorResponse($response, 404, 'Profile not found');
        }
    }

    public function put(Request $request, Response $response): Response {
        $json = json_decode(file_get_contents('php://input'), true);
        if ( json_last_error() === JSON_ERROR_NONE ) {
            if ( ! array_key_exists('name', $json) ) {
                return $this->errorResponse($response, 400, 'Field required: name');
            }
            if ( ! array_key_exists('age', $json) ) {
                return $this->errorResponse($response, 400, 'Field required: age');
            }
            $sth = $this->db->prepare('INSERT INTO profile (`name`,`age`) VALUES (?, ?)');
            $sth->bindValue(1, $json['name'], \PDO::PARAM_STR);
            $sth->bindValue(2, $json['age'], \PDO::PARAM_INT);
            $sth->execute();
            return $this->successResponse($response, array('profile_id' => $this->db->lastInsertId()));
        } else {
            return $this->errorResponse($response, 400, 'Malformed request');
        }
    }

    private function jsonResponse(Response $response, int $code, array $json): Response {
        $response->getBody()->write(json_encode($json));
        return $response->withHeader('Content-Type', 'application/json')->withStatus($code);
    }

    private function successResponse(Response $response, array $json): Response {
        if ( array_key_exists('error', $json) === false ) {
            $json['error'] = 0;
        }
        if ( array_key_exists('message', $json) === false ) {
            $json['message'] = '';
        }
        return $this->jsonResponse($response, 200, $json);
    }

    private function errorResponse(Response $response, int $code, string $message): Response {
        return $this->jsonResponse($response, $code, array('error' => $code, 'message' => $message));
    }

}
