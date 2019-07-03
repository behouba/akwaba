/* WARNING THIS SCRIPT DO NOT ENTIRELY MATCH WITH THE CURRENT DATABASE. IT SHOULD BE USED AS BLUEPRINT OR
SOMETHING ELSE NOT AS DATABASE'S TABLES RECOVERY OPTION */


CREATE DATABASE akwaba_express
    WITH 
    OWNER = behouba
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1;

-- account_type table store different online account type proposed by akwaba express to custome
-- two main account type are: 
-- *individual(for customer who ship casually) and 
-- *business (for customer who are business owner who need to ship more regulary)
CREATE TABLE public.account_types (
    account_type_id smallint NOT NULL,
    name character varying NOT NULL,
    description text NOT NULL,
    PRIMARY KEY (account_type_id)
);


CREATE TABLE public.customers (
    customer_id SERIAL NOT NULL,
    name character varying NOT NULL,
    first_name character varying,
    last_name character varying,
    phone character varying NOT NULL,
    email character varying NOT NULL,
    password character varying NOT NULL,
    account_type_id smallint NOT NULL DEFAULT 1,
    PRIMARY KEY (customer_id),
    FOREIGN KEY (account_type_id)
        REFERENCES public.account_types (account_type_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- address table store addresses saved by customer (mainly business customer)
-- to help them with a kind of address book where they can select from a list of reusable addresses
-- insted of having to retype the same address again an again.
CREATE TABLE public.addresses (
    address_id SERIAL NOT NULL,
    contact_name character varying NOT NULL,
    phone character varying NOT NULL,
    google_place character varying NOT NULL,
    description character varying NOT NULL,
    customer_id integer NOT NULL,
    PRIMARY KEY (address_id),
    FOREIGN KEY (customer_id)
        REFERENCES public.customers (customer_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE   
);


CREATE TABLE  public.order_statuses (
    order_status_id smallint NOT NULL,
    name character varying NOT NULL,
    description character varying,
    PRIMARY KEY (order_status_id)
);

CREATE TABLE public.orders (
    order_id bigserial NOT NULL,
    customer_id integer, -- NOT NULL will depend if we will allow ordering without registration
    time_created timestamp without time zone NOT NULL DEFAULT NOW(),
    time_closed  timestamp without time zone,
    order_status_id smallint NOT NULL,
    shipments jsonb NOT NULL,
    PRIMARY KEY (order_id),
    FOREIGN KEY (customer_id)
        REFERENCES public.customers (customer_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (order_status_id)
        REFERENCES public.order_statuses (order_status_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- locations tables 
CREATE TABLE public.countries (
    country_id smallint NOT NULL,
    name character varying NOT NULL,
    PRIMARY KEY (country_id)
);


CREATE TABLE public.cities (
    city_id serial NOT NULL,
    name character varying NOT NULL,
    -- office_id integer NOT NULL,
    country_id integer NOT NULL,
    PRIMARY KEY (city_id),
    FOREIGN KEY (country_id)
        REFERENCES public.countries (country_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
);


CREATE TABLE public.offices (
    office_id serial NOT NULL,
    address character varying NOT NULL,
    description character varying,
    city_id integer NOT NULL,
    manager_id integer NOT NULL,
    PRIMARY KEY (office_id),
    FOREIGN KEY (city_id)
        REFERENCES public.cities (city_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
-- position table store all possible positions of akwba express workers
CREATE TABLE public.positions (
    position_id smallint NOT NULL,
    name character varying NOT NULL,
    description character varying,
    PRIMARY KEY (position_id)
);

CREATE TABLE public.employees (
    employee_id serial NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    login character varying,
    password character varying,
    active_from timestamp without time zone NOT NULL DEFAULT NOW(),
    active_to timestamp without time zone,
    is_active boolean NOT NULL,
    position_id smallint NOT NULL,
    office_id integer NOT NULL,
    PRIMARY KEY (employee_id),
    FOREIGN KEY (position_id)
        REFERENCES public.positions (position_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (office_id)
        REFERENCES public.offices (office_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- reference manager_id column of table office as foreign key from employee table
ALTER TABLE public.offices
    ADD FOREIGN KEY (manager_id)
    REFERENCES public.employees (employee_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;


-- reference office_id column of table city as foreign key from employee office
ALTER TABLE public.cities
    ADD FOREIGN KEY (office_id)
    REFERENCES public.offices (office_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;









CREATE TABLE public.shipment_statuses (
    shipment_status_id smallint NOT NULL,
    name character varying NOT NULL,
    description character varying,
    PRIMARY KEY (shipment_status_id)
);

-- insert into shipment_states (shipment_state_id, name, code) values (1, 'Le colis est en attente de ramassage par le coursier', 'PENDING_PICKUP');
-- insert into shipment_states (shipment_state_id, name, code) values (2, 'Le colis a été ramassé par le coursier chez l''expéditeur', 'PICKED_UP');
-- insert into shipment_states (shipment_state_id, name, code) values (3, 'Le ramassage du colis a échoué', 'PICKED_UP_FAILED');
-- insert into shipment_states (shipment_state_id, name, code) values (4, 'Le colis a quitté sa zone d''expédition', 'LEFT_ORIGIN_PLACE');
-- insert into shipment_states (shipment_state_id, name, code) values (5, 'Le colis est arrivé dans une zone de transit', 'ARRIVED_AT_TRANSIT_PLACE');
-- insert into shipment_states (shipment_state_id, name, code) values (6, 'Le colis a quitté l''agence la zone de transit', 'LEFT_TRANSIT_PLACE');
-- insert into shipment_states (shipment_state_id, name, code) values (7, 'Le colis est arrivé dans la zone de livraison', 'ARRIVED_AT_DELIVERY_PLACE');
-- insert into shipment_states (shipment_state_id, name, code) values (8, 'Le colis a été livré avec succès', 'DELIVERED');
-- insert into shipment_states (shipment_state_id, name, code) values (9, 'La livraison du colis au destinataire a échoué', 'DELIVERY_FAILED');
-- insert into shipment_states (shipment_state_id, name, code) values (10, 'Le colis a été retourné à l''expéditeur', 'RETURNED');
-- insert into shipment_states (shipment_state_id, name, code) values (11, 'Un problème est survenu durant l''acheminement du colis', 'EXCEPTIONAL_FAILURE');


CREATE TABLE public.payment_options (
    payment_option_id smallint NOT NULL,
    name character varying NOT NULL,
    description character varying,
    PRIMARY KEY (payment_option_id)
);

CREATE TABLE public.weight_intervals (
    weight_interval_id smallint NOT NULL,
    name character varying NOT NULL,
    base_cost integer NOT NULL,
    PRIMARY KEY (weight_interval_id)
);




CREATE TABLE public.shipments (
    shipment_id bigserial NOT NULL,
    sender jsonb NOT NULL,
    recipient jsonb NOT NULL,
    time_accepted timestamp without time zone NOT NULL DEFAULT NOW(),
    time_delivered timestamp without time zone,
    order_id bigint NOT NULL,
    shipping_cost integer NOT NULL,
    pickup_city_id int NOT NULL, -- should think which option is best between office_id or city_id (pickup and delivery area)
    delivery_city_id int NOT NULL,
    weight_interval_id smallint NOT NULL,
    weight numeric NOT NULL,
    PRIMARY KEY (shipment_id),
    FOREIGN KEY (order_id)
        REFERENCES public.orders (order_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (pickup_city_id)
        REFERENCES public.cities (city_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (delivery_city_id)
        REFERENCES public.cities (city_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (weight_interval_id)
        REFERENCES public.weight_intervals (weight_interval_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE public.assignments (
    assignment_id bigserial NOT NULL,
    office_id integer NOT NULL,
    shipment_id integer NOT NULL,
    time_assigned timestamp without time zone NOT NULL DEFAULT NOW(),
    time_completed timestamp without time zone,
    FOREIGN KEY (office_id)
        REFERENCES public.offices (office_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (shipment_id)
        REFERENCES public.shipments (shipment_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE public.trackings (
    tracking_id bigserial NOT NULL,
    shipment_id bigint NOT NULL,
    shipment_status_id smallint NOT NULL,
    city_id integer NOT NULL,
    time_inserted timestamp without time zone NOT NULL DEFAULT NOW(),
    PRIMARY KEY (tracking_id),
    FOREIGN KEY (shipment_id)
        REFERENCES public.shipments (shipment_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (shipment_status_id)
        REFERENCES public.shipment_statuses (shipment_status_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (city_id)
        REFERENCES public.cities (city_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

