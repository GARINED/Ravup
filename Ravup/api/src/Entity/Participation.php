<?php

namespace App\Entity;

use ApiPlatform\Core\Annotation\ApiResource;
use Doctrine\ORM\Mapping as ORM;
use App\Controller\ParticipationController;

/**
 * @ApiResource(
 *     collectionOperations={
 *          "get",
 *          "post"={
 *              "method"="POST",
 *              "controller"=ParticipationController::class
 *          }
 *      },
 *     itemOperations={"get", "put"},
 *     normalizationContext={"groups"={"participation:read"}},
 *     denormalizationContext={"groups"={"participation:write"}}
 * )
 * @ORM\Entity(repositoryClass="App\Repository\ParticipationRepository")
 */
class Participation
{
    /**
     * @ORM\Id()
     * @ORM\GeneratedValue(strategy="UUID")
     * @ORM\Column(type="guid")
     */
    private $id;

    /**
     * @ORM\ManyToOne(targetEntity="App\Entity\User", inversedBy="eventParticipations")
     * @ORM\JoinColumn(nullable=false)
     */
    private $relatedUser;

    /**
     * @ORM\Column(type="integer")
     */
    private $participate;

    /**
     * @ORM\ManyToOne(targetEntity="App\Entity\Event", inversedBy="userParticipations")
     * @ORM\JoinColumn(nullable=false)
     */
    private $event;

    public function getId()
    {
        return $this->id;
    }

    public function getRelatedUser(): ?User
    {
        return $this->relatedUser;
    }

    public function setRelatedUser(?User $relatedUser): self
    {
        $this->relatedUser = $relatedUser;

        return $this;
    }

    public function getParticipate(): ?int
    {
        return $this->participate;
    }

    public function setParticipate(int $participate): self
    {
        $this->participate = $participate;

        return $this;
    }

    public function getEvent(): ?Event
    {
        return $this->event;
    }

    public function setEvent(?Event $event): self
    {
        $this->event = $event;

        return $this;
    }
}
