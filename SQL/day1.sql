-- Audit de la table orders:

-- 1.Vue d'ensemble:
select 
count(*) as nb_commandes,
min(order_delivered_customer_date) as premiere_commande_complete,
max(order_delivered_customer_date) as dernire_commande_complete
from `olist-project-500108.olist_project_dataset.orders`
;

--2. Identification d'anomalies:

-- parmi les status='delivered': pas de date de récéption côté client mais la proportion est minime (0.01% des status='delivered')

select
countif(order_status='delivered' and order_delivered_customer_date is null) as nb_anomalies,
round(countif(order_status='delivered' and order_delivered_customer_date is null)/countif(order_status='delivered')*100,2) as pct_anomalies ,
countif(order_status='delivered') as total_delivred
from `olist-project-500108.olist_project_dataset.orders`
;

-- Incohérence de date :23 commandes livrées avant la remise transporteur
select 
countif(order_delivered_customer_date<order_delivered_carrier_date) nb_anomalies,
round((countif(order_delivered_customer_date<order_delivered_carrier_date)/count(*))*100,2) as pct_anomalies
from `olist-project-500108.olist_project_dataset.orders` 
;

--3. Identification des commandes avec un long temps de traitement :

-- préparation en vue d'une jointure avec les avis (order_reviews) on remarque que certaines commandes ont plusieurs avis, pour simplifier on se restreint à un avis par commande en se référant à l'avis le plus récent:

create or replace view  `olist-project-500108.olist_project_dataset.v_reviews_dedup` as
select * except(rn)
from (
  select *, row_number() over (partition by order_id order by  review_answer_timestamp desc) as rn
  from `olist-project-500108.olist_project_dataset.order_reviews`
)
where rn = 1
;

-- analyse 
with order_date as (select
order_id,order_status,order_purchase_timestamp,max(order_purchase_timestamp) over() as last_order
from `olist-project-500108.olist_project_dataset.orders` ),

diff_date as (
  select o.order_id,o.order_status,r.review_score,date_diff(o.last_order, o.order_purchase_timestamp, day) as jours_stagne
  from order_date as o
    left join `olist-project-500108.olist_project_dataset.v_reviews_dedup` as r
      on o.order_id=r.order_id
      where o.order_status not in ('delivered','canceled','unavailable')
)
select
order_status,
count(*) nb_commandes_bloquees,
round(avg(diff_date.jours_stagne),2) as moyenne_jours_stagnation,
round(avg(diff_date.review_score),2) as score_review

from diff_date
group by all
order by avg(diff_date.jours_stagne) desc
;



--4. Création d'une vue pour poursuivre l'analyse avec la table orders

-- Dans cette vue: on ne garde que les commandes livrées,on ajoute une colonne qui mesure l'écart entre date de livraison et livraison estimé , on ne supprime pas les anomalies mais on les rend visibles avec des flags en cas d'ajustements futurs

--Focus exclusif sur les commandes livrées ('delivered') pour pouvoir mesurer les performances logistiques
 
create or replace view `olist-project-500108.olist_project_dataset.v_orders_clean` as
select
order_id,
  customer_id,
  order_status,
  order_purchase_timestamp,
  order_delivered_carrier_date,
  order_delivered_customer_date,
  order_estimated_delivery_date,

  -- Indicateur de fiabilité : Jours d'écart entre réception réelle et réception estimée
  -- Un résultat positif indique un retard par rapport à l'estimation
  date_diff(date(order_delivered_customer_date), date(order_estimated_delivery_date), day) as ecart_jours_estime_vs_reel,

  -- FLAG QUALITÉ : Commande marquée 'delivered' mais sans date de remise client
  (order_delivered_customer_date is null) as flag_date_manquante,

  ---- FLAG ANOMALIE : 'Time Travel' où la réception précède l'expédition (23 lignes)
  (order_delivered_customer_date < order_delivered_carrier_date) as flag_incoherence_dates
from `olist-project-500108.olist_project_dataset.orders`
where order_status = 'delivered'
;


-- Aperçu
select *
from `olist-project-500108.olist_project_dataset.v_orders_clean`
limit 10
;
