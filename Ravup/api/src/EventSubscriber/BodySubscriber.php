<?php

declare(strict_types = 1);

namespace App\EventSubscriber;

use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Symfony\Component\HttpKernel\Event\GetResponseEvent;
use Symfony\Component\HttpKernel\KernelEvents;
use function in_array;


class BodySubscriber implements EventSubscriberInterface
{
    public static function getSubscribedEvents(): array
    {
        return [
            KernelEvents::REQUEST => [
                'onKernelRequest',
                10,
            ],
        ];
    }

    public function onKernelRequest(GetResponseEvent $event): void
    {
        $request = $event->getRequest();

        if (empty($request->getContent())) {
            return;
        }

        if (in_array($request->getContentType(), [null, 'json', 'txt'], true)) {
            $request->request->replace(json_decode($request->getContent(), true));
        }
    }
}