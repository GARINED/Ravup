<?php
/**
 * Created by PhpStorm.
 * User: GARINE_D
 * Date: 3/13/19
 * Time: 12:54 AM
 */

namespace App\Controller;


use App\Entity\Date;
use App\Entity\Event;
use DateTime;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\RequestStack;

class DateController extends Controller
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
        $dateString = $request->get("date");
        $duration = $request->get("duration");
        $eventId = $request->get("event");
        $event = $this->em->getRepository(Event::class)->findOneBy([
            'id' => $eventId
        ]);
        if (!$event) {
            return new JsonResponse("event doesn't exist", 401);
        }
        $dateTime = new \DateTime($dateString);
        $date = new Date();
        $date->setDate($dateTime);
        $date->setDuration($duration);
        $date->setEvent($event);
        $event->addDateList($date);

        $this->em->persist($date);
        $this->em->persist($event);
        $this->em->flush();

        return $date;
    }
}