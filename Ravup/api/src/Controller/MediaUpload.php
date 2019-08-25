<?php
/**
 * Created by PhpStorm.
 * User: GARINE_D
 * Date: 3/13/19
 * Time: 12:54 AM
 */

namespace App\Controller;


use App\Entity\Event;
use App\Entity\Media;
use App\Entity\User;
use App\Repository\UserRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\File\File;
use Symfony\Component\HttpFoundation\File\UploadedFile;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\RequestStack;

class MediaUpload extends Controller
{
    private $requestStack;
    private $em;

    public function __construct(RequestStack $requestStack, EntityManagerInterface $entityManager)
    {
        $this->requestStack = $requestStack;
        $this->em = $entityManager;
    }

    public function __invoke($data)
    {
        $request = $this->requestStack->getCurrentRequest();
        $media = new Media();
        $userId = $request->get("owner");
        $user = $this->em->getRepository(User::class)->findOneBy([
            'id' => $userId
        ]);
        $profile = $request->get("profile");
        $coverEvent = $request->get("coverEvent");
        if (!$user) {
            return new JsonResponse("user doesn't exist", 401);
        }
        if ($profile && $profile == "true") {
            $user->setProfilePicture($media);
            $this->em->persist($user);
        }
        else if (!$coverEvent || $coverEvent == "false") {
            $user->addMedium($media);
            $this->em->persist($user);
        }
        $media->setOwner($user);
        $file = $request->files->get("file");
        if ($file) {
            $mimeType = $file->getMimeType();
            $fileName = md5(uniqid()).'.'.$file->guessExtension();
            $file->move($this->getParameter('upload_directory'), $fileName);
            $media->setMimetype($mimeType);
            $media->setFileId($fileName);
        }
        else {
            return new JsonResponse("file doesn't exist", 404);
        }
        $this->em->persist($media);
        $this->em->flush();

        return $media;
    }
}