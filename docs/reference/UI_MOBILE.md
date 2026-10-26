# Interfaces portrait — état de vérification

Lot du 23 octobre 2026 : **sources installées, validation complète en attente**. Ne pas présenter les sept pages comme visuellement validées. Preuve partielle et diagnostics : studio/qa/portrait-catalog-result.json.

## Implémentation

Un seul script actif modifié : studio/GameHub.client.luau → StarterPlayer.StarterPlayerScripts.GameHub. Copie initiale dans ServerStorage.BeforePortraitCatalog.GameHub. Pas de changement serveur, profil, reçus ou paiements.

portraitCatalog active la fenêtre haute pour les sept pages tactiles lorsque la hauteur dépasse la largeur. La largeur logique reste 720 ; le facteur dépend de la vue réelle. Les catégories sont réparties en deux lignes (quatre puis trois), les actions et la fermeture sont arrondies au pixel logique supérieur pour rester à au moins 44 unités UI après UIScale. Les dimensions inférieures à 100×100 sont ignorées en attendant la première vraie taille de caméra.

Armurerie : cartes 320 de haut, aperçu 128×128, titre et caractéristiques à droite, achat/équipement pleine largeur en bas. Atelier, cadeaux, options et Robux : cartes empilées 300, actions pleine largeur. Pets : fusion et équipement côte à côte. Missions : cartes compactes 190 conservées, dans la nouvelle fenêtre/les nouveaux onglets. Hauteur de carte ajustée si le minimum d'action exige plus de place sur un petit écran. Les mesures minimales annoncées sont des unités de décalage Roblox, pas une mesure physique au doigt.

Lignes et textes plus grands ; icônes décoratives déplacées, barres de progression étendues. Le pied de page portrait utilise une taille de texte fixe et un espace accru. Sa contrainte minimale précédente de 18 empêchait la réduction sous UIScale : minimum ramené à 9, sans changer le texte principal des cartes. Les actions désactivées ne sont ni actives ni sélectionnables ; aucune autorité économique déplacée vers le client.

Le changement de page remet le défilement en haut. Un rafraîchissement de la même page garde sa position, bornée au contenu. Un numéro de rendu empêche une restauration différée d'un ancien rendu de s'appliquer au nouveau. À tester en achat/rotation réels. Hors portrait, les dimensions larges, les icônes d'onglets et les colonnes sont restaurées par layoutWindow.

## Preuves et limites

Retour utilisateur du 23 octobre : la carte s’affiche normalement en cliquant Jouer dans Studio. L’ancien fond noir des captures n’est donc pas un défaut du jeu confirmé chez l’utilisateur. Aucune modification d’éclairage réalisée ; les sept pages et les animations restent à contrôler visuellement.

Parcours Jouer activé à la souris sur une vraie session client : HasStarted false → true / InGameMenu false, sans fixture serveur modifiant le démarrage. Le dernier essai de ce parcours précède uniquement les corrections finales du pied de page et de la garde 1×1. L'essai initial avait cliqué Options en utilisant une correction d'origine inadaptée ; fermeture puis centre absolu brut ont réellement déclenché Jouer. Ne pas généraliser une formule de coordonnées à tous les états de l'outil.

Atelier : titres/descriptions/boutons et onglets mesurés dans une vraie vue iPhone 17 Pro 401×778 ; les contrôles passaient après correction temporaire de la taille minimale du pied de page, persistée ensuite. Les premiers échecs fermeture <44 et footer ont conduit aux corrections. Cela ne valide pas les autres pages ni toutes les versions finales.

La capture ancienne des Options a été inspectée avant la disposition finale des onglets ; aucune nouvelle capture finale n'a abouti. Plusieurs démarrages de client ont ensuite montré une caméra 1×1 et un PlayerGui 800×600/504. Ne pas compter ces mesures comme un échec de géométrie du produit. Les demandes de capture et une entrée souris en attente n'ont pas donné de résultat ; attentes annulées après vérification indépendante de l'état vivant Play et du viewport, sans succès présumé. La tentative Set3dRenderingEnabled était interdite par la capacité RobloxScript et n'a rien changé. Aucun contournement de permission.

Correctif des preuves précédentes : la sélection de preset par `iphone%s*(%d+)` ignorait les espaces insécables des noms localisés et choisissait iphone_7. Les mesures 666×374 / 374×666 du fusil étaient donc sur iPhone 7, pas 17 Pro. docs/reference/ARMES_A_FEU.md, RELAIS_IA.md et shotgun-result.json sont corrigés. Pour sélectionner à nouveau : rechercher iphone dans le nom puis extraire le premier nombre séparément ; lire GetDeviceAsync après sélection et le noter dans le rapport. Ne pas modifier les autres rapports historiques sans leur propre preuve de preset.

## Ajout suivant à inclure dans les captures

Le lot tirs de tête a ajouté le rappel « Armes a feu : tete x1.5 » dans la note d'armurerie, sans changer le layout. Ses dégâts/protocoles ont passé 93 contrôles, mais cette note et la bulle TETE!/ReducedMotion restent visuellement non vérifiées. Le client était toujours 1×1. Voir docs/reference/TIRS_A_LA_TETE.md.

## Disponibilité du rendu au 26 octobre

Le correctif d’orientation des armes a été mesuré avec une vraie caméra PC 1447×801 et iPhone 17 Pro 750×381 / 401×778, puis une capture portrait à l’impact enregistrée. L’ancien blocage 1×1 n’était pas présent dans ce lot. Les sept pages UI restent à reprendre : ces tests ne les couvrent pas.

## Reprise de la validation

1. Redécouvrir Studio, vérifier Edit/Play et que le client a un vrai ViewportSize (>100×100). Vérifier que l'onglet client est visible. Ne pas réinitialiser Play sur le seul dépassement d'une attente.
2. Simuler le vrai iPhone récent avec GetDeviceListAsync et GetDeviceInfoAsync ; noter GetDeviceAsync. Portrait puis paysage et PC ; une seconde largeur portrait 320 est à contrôler. Toujours attendre après les setters et remettre default/LandscapeLeft à la fin.
3. En Play SessionStudio, installer temporairement studio/qa/CatalogLayout.client.luau dans PlayerScripts côté Client. Le BindableFunction PlayerGui.InspectCatalogQA retourne les rectangles/textes/erreurs de la page courante. Il refuse une vue 1×1. Aucun script QA en Edit.
4. Ouvrir chaque page par vrais clics. Lire InspectCatalogQA:Invoke(false) après stabilisation. Pour le bas du catalogue, demander Invoke(true), laisser la disposition se stabiliser puis mesurer à nouveau ; vérifier que la dernière action est atteignable et hors du pied de page. Ne pas attendre RenderStepped à l'intérieur d'une invocation MCP si le client ne rend pas.
5. Préparer seulement le profil de test temporaire via un Script serveur ordinaire : pièces/niveaux/fragments/récompense prête. Acheter vie/vitesse/arme depuis l'UI loin des stands ; fusionner/équiper un pet ; réclamer un cadeau ; basculer une option. Lire les vrais résultats serveur. Contrôler achat verrouillé et Robux désactivés sans lancer un paiement.
6. Contrôler retour paysage/PC, position conservée au rafraîchissement, remise en haut au changement de page, textes longs et ReducedMotion. Capturer les pages finales, puis arrêter Play et auditer 43 scripts.

Références Context7 consultées : [adaptation des interfaces](https://github.com/roblox/creator-docs/blob/main/content/en-us/production/publishing/adaptive-design.md), [ScrollingFrame](https://github.com/roblox/creator-docs/blob/main/content/en-us/ui/scrolling-frames.md), [ViewportSize](https://create.roblox.com/docs/reference/engine/classes/Camera). Codex on Crack doctor : workflow-ready, sans rôle délégué ; travail direct. Panel : state_unreadable, aucune approbation revendiquée.
