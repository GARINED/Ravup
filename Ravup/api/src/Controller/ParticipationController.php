<?php
/**
 * Created by PhpStorm.
 * User: GARINE_D
 * Date: 3/13/19
 * Time: 12:54 AM
 */

namespace App\Controller;



use App\Entity\Event;
use App\Entity\Notification;
use App\Entity\Participation;
use App\Entity\User;
use Doctrine\ORM\EntityManagerInterface;
use http\Message;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\RequestStack;
use Symfony\Component\Security\Core\Security;

class ParticipationController extends Controller
{
    private $requestStack;
    private $em;
    private $security;

    public function __construct(RequestStack $requestStack, EntityManagerInterface $entityManager, Security $security)
    {
        $this->requestStack = $requestStack;
        $this->em = $entityManager;
        $this->security = $security;
    }

    public function __invoke($data)
    {
        $request = $this->requestStack->getCurrentRequest();
        $participate = $request->get("participate");
        $eventId = $request->get("eventId");
        $event = $this->em->getRepository(Event::class)->findOneBy([
            'id' => $eventId
        ]);
        $userId = $request->get("relatedUserId");
        $user = $this->em->getRepository(User::class)->findOneBy([
            'id' => $userId
        ]);
        if (!$event) {
            return new JsonResponse("event doesn't exist", 401);
        }
        else if (!$user) {
            return new JsonResponse("user doesn't exist", 401);
        }
        $participation = new Participation();
        $participation->setParticipate($participate);
        $participation->setEvent($event);
        $participation->setRelatedUser($user);

        $notification = new Notification();
        $notification->setCreator($this->security->getToken()->getUser());
        $notification->setEnabled(true);
        $notification->setRecipient($user);
        if ($this->security->getToken()->getUser()->getId() == $user->getId()) {
            $message = "Vous venez de créer un nouvel événement.";
        }
        else {
            $message = $this->security->getUser()->getUsername()." vous invite à un nouvel événement !";
        }
        $notification->setMessage($message);
        $notification->setType("event");
        $notification->setInfo($event->getId());

        $this->em->persist($notification);
        $this->em->persist($participation);
        $this->em->flush();

        return $participation;
    }
}