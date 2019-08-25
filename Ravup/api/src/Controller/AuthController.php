<?php

namespace App\Controller;

use App\Entity\Structure;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\RequestStack;
use Symfony\Component\HttpFoundation\Response;
use App\Entity\User;
use Symfony\Component\Security\Core\Encoder\UserPasswordEncoderInterface;


class AuthController extends AbstractController
{
    public function register(Request $request, UserPasswordEncoderInterface $encoder)
    {
        $em = $this->getDoctrine()->getManager();

        $username = $request->request->get('username');
        $password = $request->request->get('password');
        $email = $request->request->get('email');
        if ($username == "" || $password == "" || $email == "") {
            return new JsonResponse("invalid Field", 401);
        }

        $user = $em->getRepository(User::class)->findBy([
           'username' => $username
        ]);
        if ($user) {
            return new JsonResponse("user already exist", 401);
        }
        $structure = $em->getRepository(Structure::class)->findOneBy([
            'name' => 'Ravup'
        ]);
        if (!$structure) {
            return new JsonResponse("structure doesn't exist", 401);
        }
        $user = new User();
        $user->setUsername($username);
        $user->setPassword($encoder->encodePassword($user, $password));
        $user->setEmail($email);
        $user->setEnabled(true);
        $user->setRoles(["ROLE_RAVUP"]);
        $user->setStructure($structure);
        $em->persist($user);
        $em->flush();
        return new Response(sprintf('User %s successfully created', $user->getUsername()));
    }
    public function api()
    {
        return new Response(sprintf('Logged in as %s', $this->getUser()->getUsername()));
    }
}