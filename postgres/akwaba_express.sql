--
-- PostgreSQL database dump
--

-- Dumped from database version 10.10 (Ubuntu 10.10-0ubuntu0.18.04.1)
-- Dumped by pg_dump version 11.4

-- Started on 2019-11-24 06:59:52 MSK

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 196 (class 1259 OID 18118)
-- Name: account_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.account_types (
    account_type_id smallint NOT NULL,
    name character varying NOT NULL,
    description text
);


--
-- TOC entry 197 (class 1259 OID 18124)
-- Name: addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.addresses (
    contact_name character varying NOT NULL,
    phone character varying NOT NULL,
    google_place character varying NOT NULL,
    description character varying NOT NULL,
    user_id integer NOT NULL
);


--
-- TOC entry 198 (class 1259 OID 18130)
-- Name: areas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.areas (
    area_id integer NOT NULL,
    name character varying NOT NULL,
    city_id integer NOT NULL
);


--
-- TOC entry 199 (class 1259 OID 18136)
-- Name: areas_area_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.areas_area_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3131 (class 0 OID 0)
-- Dependencies: 199
-- Name: areas_area_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.areas_area_id_seq OWNED BY public.areas.area_id;


--
-- TOC entry 200 (class 1259 OID 18144)
-- Name: cities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cities (
    city_id integer NOT NULL,
    name character varying NOT NULL,
    country_id integer NOT NULL,
    office_id integer
);


--
-- TOC entry 201 (class 1259 OID 18150)
-- Name: cities_city_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cities_city_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3132 (class 0 OID 0)
-- Dependencies: 201
-- Name: cities_city_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cities_city_id_seq OWNED BY public.cities.city_id;


--
-- TOC entry 202 (class 1259 OID 18152)
-- Name: countries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.countries (
    country_id smallint NOT NULL,
    name character varying NOT NULL
);


--
-- TOC entry 207 (class 1259 OID 18185)
-- Name: employees; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employees (
    employee_id integer NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    login character varying,
    password character varying,
    active_from timestamp without time zone DEFAULT now() NOT NULL,
    active_to timestamp without time zone,
    is_active boolean DEFAULT true NOT NULL,
    position_id smallint NOT NULL,
    office_id integer NOT NULL
);


--
-- TOC entry 208 (class 1259 OID 18193)
-- Name: employees_access_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employees_access_history (
    employee_id integer NOT NULL,
    access_time timestamp without time zone DEFAULT now() NOT NULL,
    ip_address character varying,
    is_from_mobile boolean
);


--
-- TOC entry 209 (class 1259 OID 18200)
-- Name: employees_employee_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.employees_employee_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3133 (class 0 OID 0)
-- Dependencies: 209
-- Name: employees_employee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.employees_employee_id_seq OWNED BY public.employees.employee_id;


--
-- TOC entry 210 (class 1259 OID 18202)
-- Name: order_states; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_states (
    order_state_id smallint NOT NULL,
    name character varying NOT NULL,
    code character varying NOT NULL,
    description character varying
);


--
-- TOC entry 211 (class 1259 OID 18208)
-- Name: orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.orders (
    order_id bigint NOT NULL,
    user_id integer DEFAULT 1 NOT NULL,
    time_created timestamp without time zone DEFAULT now() NOT NULL,
    time_closed timestamp without time zone,
    sender_name character varying NOT NULL,
    sender_phone character varying NOT NULL,
    sender_area_id integer NOT NULL,
    sender_address character varying NOT NULL,
    recipient_name character varying NOT NULL,
    recipient_phone character varying NOT NULL,
    recipient_area_id integer NOT NULL,
    recipient_address character varying NOT NULL,
    shipment_category_id smallint NOT NULL,
    nature character varying NOT NULL,
    payment_option_id smallint NOT NULL,
    cost integer NOT NULL,
    distance numeric NOT NULL,
    order_state_id smallint NOT NULL
);


--
-- TOC entry 212 (class 1259 OID 18216)
-- Name: payment_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payment_options (
    payment_option_id smallint NOT NULL,
    name character varying NOT NULL,
    description character varying
);


--
-- TOC entry 213 (class 1259 OID 18222)
-- Name: shipment_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shipment_categories (
    shipment_category_id smallint NOT NULL,
    name character varying NOT NULL,
    min_cost integer,
    max_cost integer
);


--
-- TOC entry 214 (class 1259 OID 18228)
-- Name: shipments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shipments (
    shipment_id bigint NOT NULL,
    order_id bigint NOT NULL,
    user_id integer NOT NULL,
    sender_name character varying NOT NULL,
    sender_phone character varying NOT NULL,
    sender_area_id integer NOT NULL,
    sender_address character varying NOT NULL,
    recipient_name character varying NOT NULL,
    recipient_phone character varying NOT NULL,
    recipient_area_id integer NOT NULL,
    recipient_address character varying NOT NULL,
    time_created timestamp without time zone DEFAULT now() NOT NULL,
    time_delivered timestamp without time zone,
    shipment_category_id integer NOT NULL,
    cost integer NOT NULL,
    nature character varying NOT NULL,
    weight numeric DEFAULT 0 NOT NULL,
    payment_option_id integer NOT NULL,
    distance numeric NOT NULL,
    shipment_state_id smallint NOT NULL,
    current_office_id integer
);


--
-- TOC entry 215 (class 1259 OID 18236)
-- Name: full_orders; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.full_orders AS
 SELECT o.order_id,
    s.shipment_id,
    o.user_id,
    o.time_created,
    o.time_closed,
    o.sender_name,
    o.sender_phone,
    o.sender_area_id,
    a1.name AS sender_area,
    o.sender_address,
    o.recipient_name,
    o.recipient_phone,
    o.recipient_area_id,
    a2.name AS recipient_area,
    o.recipient_address,
    o.shipment_category_id,
    sc.name AS shipment_category,
    o.nature,
    o.payment_option_id,
    po.name AS payment_option,
    o.cost,
    o.distance,
    ost.order_state_id,
    ost.name AS order_state
   FROM ((((((public.orders o
     LEFT JOIN public.order_states ost ON ((o.order_state_id = ost.order_state_id)))
     LEFT JOIN public.shipment_categories sc ON ((sc.shipment_category_id = o.shipment_category_id)))
     LEFT JOIN public.payment_options po ON ((po.payment_option_id = o.payment_option_id)))
     LEFT JOIN public.areas a1 ON ((a1.area_id = o.sender_area_id)))
     LEFT JOIN public.areas a2 ON ((a2.area_id = o.recipient_area_id)))
     LEFT JOIN public.shipments s ON ((s.order_id = o.order_id)));


--
-- TOC entry 216 (class 1259 OID 18241)
-- Name: shipment_states; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shipment_states (
    shipment_state_id smallint NOT NULL,
    name character varying NOT NULL,
    code character varying,
    description character varying
);


--
-- TOC entry 217 (class 1259 OID 18247)
-- Name: full_shipments; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.full_shipments AS
 SELECT s.shipment_id,
    s.order_id,
    s.user_id,
    s.sender_name,
    s.sender_phone,
    s.sender_area_id,
    sender_area.name AS sender_area,
    s.sender_address,
    s.recipient_name,
    s.recipient_phone,
    s.recipient_area_id,
    recipient_area.name AS recipient_area,
    s.recipient_address,
    s.time_created,
    s.time_delivered,
    s.shipment_category_id,
    sc.name AS shipment_category,
    s.cost,
    s.shipment_state_id,
    st.name AS shipment_state,
    s.weight,
    s.payment_option_id,
    po.name AS payment_option,
    s.distance,
    s.nature,
    s.current_office_id,
    c1.office_id AS pickup_office_id,
    c2.office_id AS delivery_office_id
   FROM (((((((public.shipments s
     LEFT JOIN public.areas sender_area ON ((sender_area.area_id = s.sender_area_id)))
     LEFT JOIN public.areas recipient_area ON ((recipient_area.area_id = s.recipient_area_id)))
     LEFT JOIN public.shipment_categories sc ON ((sc.shipment_category_id = s.shipment_category_id)))
     LEFT JOIN public.shipment_states st ON ((st.shipment_state_id = s.shipment_state_id)))
     LEFT JOIN public.payment_options po ON ((po.payment_option_id = s.payment_option_id)))
     LEFT JOIN public.cities c1 ON ((c1.city_id = sender_area.city_id)))
     LEFT JOIN public.cities c2 ON ((c2.city_id = recipient_area.city_id)));


--
-- TOC entry 204 (class 1259 OID 18165)
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    phone character varying NOT NULL,
    email character varying DEFAULT false NOT NULL,
    password character varying NOT NULL,
    account_type_id smallint DEFAULT 1 NOT NULL,
    is_email_verified boolean DEFAULT false NOT NULL,
    is_phone_verified boolean DEFAULT false NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    recovery_token character varying
);


--
-- TOC entry 218 (class 1259 OID 18252)
-- Name: mailing_data_view; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.mailing_data_view WITH (security_barrier='false') AS
 SELECT o.order_id,
    s.shipment_id,
    c.email,
    c.first_name
   FROM ((public.orders o
     LEFT JOIN public.users c ON ((o.user_id = c.user_id)))
     LEFT JOIN public.shipments s ON ((s.user_id = c.user_id)));


--
-- TOC entry 219 (class 1259 OID 18257)
-- Name: offices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.offices (
    office_id integer NOT NULL,
    name character varying NOT NULL,
    address character varying,
    city_id integer NOT NULL,
    manager_id integer,
    area_id integer NOT NULL,
    longitude numeric,
    latitude numeric,
    phone1 character varying,
    phone2 character varying
);


--
-- TOC entry 220 (class 1259 OID 18263)
-- Name: offices_office_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.offices_office_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3134 (class 0 OID 0)
-- Dependencies: 220
-- Name: offices_office_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.offices_office_id_seq OWNED BY public.offices.office_id;


--
-- TOC entry 221 (class 1259 OID 18265)
-- Name: orders_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.orders_history (
    order_id bigint NOT NULL,
    order_state_id smallint NOT NULL,
    time_created character varying DEFAULT now() NOT NULL
);


--
-- TOC entry 222 (class 1259 OID 18272)
-- Name: orders_order_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.orders_order_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3135 (class 0 OID 0)
-- Dependencies: 222
-- Name: orders_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.orders_order_id_seq OWNED BY public.orders.order_id;


--
-- TOC entry 223 (class 1259 OID 18274)
-- Name: positions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.positions (
    position_id smallint NOT NULL,
    name character varying NOT NULL,
    description character varying
);


--
-- TOC entry 224 (class 1259 OID 18280)
-- Name: shipments_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shipments_history (
    shipment_id bigint NOT NULL,
    shipment_state_id smallint NOT NULL,
    time_inserted timestamp without time zone DEFAULT now() NOT NULL,
    area_id integer NOT NULL
);


--
-- TOC entry 225 (class 1259 OID 18284)
-- Name: shipments_shipment_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.shipments_shipment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3136 (class 0 OID 0)
-- Dependencies: 225
-- Name: shipments_shipment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.shipments_shipment_id_seq OWNED BY public.shipments.shipment_id;


--
-- TOC entry 226 (class 1259 OID 18286)
-- Name: shipments_tracking; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.shipments_tracking AS
 SELECT h.shipment_id,
    st.name AS shipment_state,
    h.time_inserted,
    c.name AS city,
    a.name AS area
   FROM (((public.shipments_history h
     LEFT JOIN public.shipment_states st ON ((st.shipment_state_id = h.shipment_state_id)))
     LEFT JOIN public.areas a ON ((a.area_id = h.area_id)))
     LEFT JOIN public.cities c ON ((c.city_id = a.city_id)));


--
-- TOC entry 203 (class 1259 OID 18158)
-- Name: user_updates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_updates (
    user_id integer NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    phone character varying NOT NULL,
    time_updated timestamp without time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 205 (class 1259 OID 18176)
-- Name: users_access_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users_access_history (
    user_id integer NOT NULL,
    access_time timestamp without time zone DEFAULT now() NOT NULL,
    ip_address character varying,
    is_from_mobile boolean
);


--
-- TOC entry 206 (class 1259 OID 18183)
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3137 (class 0 OID 0)
-- Dependencies: 206
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- TOC entry 2873 (class 2604 OID 18290)
-- Name: areas area_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.areas ALTER COLUMN area_id SET DEFAULT nextval('public.areas_area_id_seq'::regclass);


--
-- TOC entry 2874 (class 2604 OID 18292)
-- Name: cities city_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cities ALTER COLUMN city_id SET DEFAULT nextval('public.cities_city_id_seq'::regclass);


--
-- TOC entry 2885 (class 2604 OID 18294)
-- Name: employees employee_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees ALTER COLUMN employee_id SET DEFAULT nextval('public.employees_employee_id_seq'::regclass);


--
-- TOC entry 2893 (class 2604 OID 18295)
-- Name: offices office_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offices ALTER COLUMN office_id SET DEFAULT nextval('public.offices_office_id_seq'::regclass);


--
-- TOC entry 2888 (class 2604 OID 18296)
-- Name: orders order_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders ALTER COLUMN order_id SET DEFAULT nextval('public.orders_order_id_seq'::regclass);


--
-- TOC entry 2892 (class 2604 OID 18297)
-- Name: shipments shipment_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipments ALTER COLUMN shipment_id SET DEFAULT nextval('public.shipments_shipment_id_seq'::regclass);


--
-- TOC entry 2881 (class 2604 OID 18293)
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- TOC entry 3099 (class 0 OID 18118)
-- Dependencies: 196
-- Data for Name: account_types; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.account_types (account_type_id, name, description) FROM stdin;
1	Régulier	\N
2	Professionnel	\N
3	admin	admin user to allow orders manager to create orders
\.


--
-- TOC entry 3100 (class 0 OID 18124)
-- Dependencies: 197
-- Data for Name: addresses; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.addresses (contact_name, phone, google_place, description, user_id) FROM stdin;
\.


--
-- TOC entry 3101 (class 0 OID 18130)
-- Dependencies: 198
-- Data for Name: areas; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.areas (area_id, name, city_id) FROM stdin;
1	Abobo, Gare	1
2	Abobo, Anador	1
3	Abobo, Samaké	1
4	Abobo, Akeikoi	1
5	Abobo, Dokui	1
6	Abobo, Zoo	1
7	Abobo, Baoulé	1
8	Abobo Sogefia	1
9	Abobo, Plaque	1
10	Abobo, Anonkoua	1
11	Abobo, Cité SOTRAPIM	1
12	Abobo, Agbekoi	1
13	Abobo, Té	1
14	Abobo, Cité Concorde SICOGI	1
15	Abobo, PK 18 Agoueto	1
16	Abobo, Sagbé Nord	1
17	Abobo, Belleville	1
18	Abobo, N’dotré	1
19	Adjamé, Saint-Michel	2
20	Adjamé, Williamsville	2
21	Adjamé,  Liberté	2
22	Adjamé, Dallas	2
23	Adjamé, Mosquée	2
24	Adjamé, Macaci	2
25	Adjamé, Sodeci	2
26	Adjamé, Paillet	2
27	Adjamé, Habitat Extension	2
28	Adjamé, Bracodi	2
29	Adjamé, Gendarmerie d’Agban	2
30	Adjamé, Terminus 14	2
31	Adjamé, Mirador	2
32	Attécoubé, Locodjro	3
33	Attécoubé, Quartier la paix	3
34	Attécoubé, Cité Fairmont	3
35	Attécoubé, Agban Village	3
36	Sebroko	3
37	Cocody, Danga	4
38	Cocody, Val Doyen 1	4
39	Cocody, Ambassades	4
40	Cocody, Mermoz	4
41	Cocody, Riviéra 1	4
42	Cocody, Riviéra 2	4
43	Cocody, Riviéra 3	4
44	Cocody, Riviéra 4	4
45	Cocody, Riviéra 5	4
46	Cocody, Anono	4
47	Cocody, M’pouto	4
48	Cocody, M’badon	4
49	Cocody, Akouédo	4
50	Cocody, Moscou	4
51	Cocody, Cité ATCI	4
52	Cocody, Bonoumin	4
53	Cocody, Université FHB	4
54	Cocody, Blockhauss	4
55	Cocody, Danga Nord	4
56	Cocody, Attoban	4
57	Cocody, Abbri 2000	4
58	Cocody, Gobelet	4
59	Cocody, Aghien	4
60	Cocody, Djibi	4
61	Cocody, Angré	4
62	Cocody, Cité SIR	4
63	Cocody, Rosier	4
64	Cocody, Riviéra Palmeraie	4
65	Cocody, 2 plateaux	4
66	Plateau	5
67	Yopougon, Selmer	6
68	Yopougon, Siporex	6
69	Yopougon, Bimbresso	6
70	Yopougon, Abadjin-kouté	6
71	Yopougon, Adiopodoumé	6
72	Yopougon, Annanéraie	6
73	Yopougon, Attié	6
74	Yopougon, Kouté	6
75	Yopougon, Banco nord	6
76	Yopougon, Gesco	6
77	Yopougon, Batim	6
78	Yopougon, Port-Bouet 2	6
79	Yopougon, Niangon-Lokoa	6
80	Yopougon, Niangon sud	6
81	Yopougon, Niangon nord	6
82	Yopougon, Abobo Doumé	6
83	Yopougon, Koweit	6
84	Yopougon, Zone industrielle	6
85	Yopougon, Sable	6
86	Yopougon, Sideci	6
87	Treichville Centre	7
88	Treichville, Zone industrielle	7
89	Treichville, Appolo	7
90	Treichville, Arras 3	7
91	Treichville, Biafra	7
92	Treichville, Cité du personnel	7
93	Treichville, CHU	7
94	Koumassi, Sicogi nord-est	8
95	Koumassi, Remblais	8
96	Koumassi, Port-Bouet II	8
97	Koumassi, Sicogi	8
98	Koumassi, Le Michigan	8
99	Marcory, Anoumabo	9
100	Marcory, Centre	9
101	Marcory, Zone 4C	9
102	Marcory, Biétry	9
103	Marcory, Potopoto	9
104	Port-bouet, Cité universitaire Vridi	10
105	Port-bouet, Abattoir	10
106	Port-bouet, Sogefia / Siporex	10
107	Port-bouet, Gonzagueville	10
108	Port-bouet, Mafiblé 1	10
109	Port-bouet, Mafible 2	10
110	Port-bouet, Ancien camp	10
111	Port-bouet, Nouveau camp	10
112	Port-bouet, Abouabou	10
113	Port-bouet, Aéroport	10
114	Bingerville	11
115	Anyama	12
\.


--
-- TOC entry 3103 (class 0 OID 18144)
-- Dependencies: 200
-- Data for Name: cities; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.cities (city_id, name, country_id, office_id) FROM stdin;
1	Abobo	1	2
4	Cocody	1	4
5	Le Plateau	1	3
6	Yopougon	1	7
7	Treichville	1	5
8	Koumassi	1	5
9	Marcory	1	5
10	Port-Bouët	1	6
11	Bingerville	1	4
3	Attécoubé	1	3
12	Anyama	1	2
2	Adjamé	1	8
\.


--
-- TOC entry 3105 (class 0 OID 18152)
-- Dependencies: 202
-- Data for Name: countries; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.countries (country_id, name) FROM stdin;
1	Côte d'Ivoire
\.


--
-- TOC entry 3110 (class 0 OID 18185)
-- Dependencies: 207
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.employees (employee_id, first_name, last_name, login, password, active_from, active_to, is_active, position_id, office_id) FROM stdin;
9	Patrice	Lumumba	admin	$2y$12$DC.U2SDcO40IFG4q9NCnme7rwrUqD.ta52ctKwZbw.b/H3Psxr5MK	2019-09-03 10:57:50.38986	\N	t	1	1
10	Soundiata	Keita	willy	$2y$12$DCnfXAwOKEJ26hqDUt3gauLve1WRwIQtRCLm3PK3RF2sllK6Z31LW	2019-09-03 10:59:15.898356	\N	t	2	8
11	Nelson	Mandela	abobo	$2y$12$CqgwDiJZWpIxaieicNoQPuN2CInH/qT3EXVggmGTzWtPgsNIDWvc6	2019-09-03 11:00:08.099668	\N	t	2	2
12	Samori	Touré	michel	$2y$12$NNfQQuiE3u2rbtrEO1ErGenpjpNz/RXczlbI/rMAD7f7ZBTNxr4tW	2019-09-03 11:00:58.461756	\N	t	2	3
13	Toussaint	Louverture	faya	$2y$12$wtAT3ew4O9jw1Md24Se6ROXILP7WMmsHYdps3I.ylyALIvLYnD1t.	2019-09-03 11:01:42.162194	\N	t	2	4
14	Martin	luther king junior	koumassi	$2y$12$I5iHeTEU4OxiUO8oIDMgkOoVm6CZ9eK3/XMAAP2Pf9hoH2sPK/tQu	2019-09-03 11:02:42.525851	\N	t	2	5
15	Malcolm	X	pb	$2y$12$holiDWagT4PPOvXm/F7xFudin1.w8nnwc5C9lNGcQVXPwYq4gEfIu	2019-09-03 11:03:46.161464	\N	t	2	6
16	Marcus	Garvey	yop	$2y$12$wz3HV130vJZ2xeH.qfyKa.YX39b85LPnpNZkVIrlj.NpN0ZAmC2UW	2019-09-03 11:04:40.887634	\N	t	2	7
\.


--
-- TOC entry 3111 (class 0 OID 18193)
-- Dependencies: 208
-- Data for Name: employees_access_history; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.employees_access_history (employee_id, access_time, ip_address, is_from_mobile) FROM stdin;
\.


--
-- TOC entry 3119 (class 0 OID 18257)
-- Dependencies: 219
-- Data for Name: offices; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.offices (office_id, name, address, city_id, manager_id, area_id, longitude, latitude, phone1, phone2) FROM stdin;
3	Agence Plateau	Adjamé, Saint Michel	2	\N	19	-4.025087	5.346901	08983642	54777964
1	Siège social	Adjamé, Williamsville	2	\N	20	-4.018281	5.363538	20370174	09122501
4	Agence Cocody	Cocody, Riviera Faya	4	\N	64	-3.938798	5.369768	07034398	46986882
2	Agence Abobo	Abobo	1	\N	1	-4.016947	5.428508	77315232	54974916
7	Agence Yopougon	Yopougon	6	\N	67	-4.095986	5.343373	49485173	46986609
6	Agence Port-Bouët	Port-Bouët	10	\N	107	-3.978708	5.258663	68053807	45313578
8	Agence Adjamé	Adjamé, Williamsville	2	\N	20	-4.018281	5.363538	09506298	54777978
5	Agence Koumassi	Koumassi, remblais	8	\N	95	-3.967840	5.296436	07059609	54139211
\.


--
-- TOC entry 3113 (class 0 OID 18202)
-- Dependencies: 210
-- Data for Name: order_states; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.order_states (order_state_id, name, code, description) FROM stdin;
1	En attente de confirmation	PENDING_ORDER	\N
2	En cours de traitement	PROCESSING	\N
3	Terminée	COMPLETED	\N
4	Annulée	CANCELED	\N
\.


--
-- TOC entry 3114 (class 0 OID 18208)
-- Dependencies: 211
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.orders (order_id, user_id, time_created, time_closed, sender_name, sender_phone, sender_area_id, sender_address, recipient_name, recipient_phone, recipient_area_id, recipient_address, shipment_category_id, nature, payment_option_id, cost, distance, order_state_id) FROM stdin;
1632345255	57	2019-08-31 12:47:25.919457	\N	KOUAME BEHOUBA 	45001685	64	carrefour abinadair 	Jean Thierry Koffi 	65325821	87	Moscou rue lenine	1	diplôme du bac	2	1250	14.819	2
1632345269	1	2019-09-04 18:10:23.132574	2019-09-04 18:12:25.750593	Ami Chia	22556010	95	gare marche	Sewa Wa	22503482	105	Port bouet phare	2	chaussures	2	1000	5.905	3
1632345254	58	2019-08-28 18:21:44.855206	\N	Marie	45578998	7	VTT kiki re	Yaata	56788899	39	fin je zcg	1	Chaussures	1	1250	14.209	4
1632345273	57	2019-09-06 10:55:56.837234	2019-09-06 12:05:18.788415	Yves Roger 	44689525	75	Banco	jean claude	99352154	114	rue des archanges	1	documents et factures	2	1500	27.234	3
1632345262	58	2019-09-04 12:09:45.329775	2019-09-04 12:12:22.908545	Ai Cha	58759855	28	jbvcdsjklpokjdcsnmx	Ma Riam	02545856	95	rdtfgyh7ujkolpèlkbhj	2	Chaussures et sacs	1	1300	13.962	4
1632345284	58	2019-09-10 12:00:20.130851	2019-09-10 14:51:18.984232	Mana Dja	06587295	87	Trechiville, pharmacie	Dia Blo	85642189	99	Anoumabo, fabrique	2	Sacs	1	1150	7.814	3
1632345277	57	2019-09-06 11:11:22.556248	2019-09-06 12:10:14.099406	Meïté clovis	64598578	54	Blockhauss	Éric zemour	46325879	20	Adjame 	1	Fournitures de bureau 	1	1150	8.047	3
1632345261	1	2019-09-02 17:59:46.235907	2019-09-04 12:24:16.658908	kouame behouba manasse	22 52 25 22	37	angre rue princesss	jean didier	22 52 25 22	5	marcory dokui	2	colis de vetements	1	1150	8.657	3
1632345274	57	2019-09-06 11:01:58.477561	2019-09-06 12:11:58.629585	Brice David 	22653245	99	Anoumabo	Binger Louis 	45785258	112	Port bouet 	2	chaussures	1	1550	25.743	3
1632345272	1	2019-09-04 18:29:01.193533	\N	Aicha soro	05784515	2	abobo	goku	78545856	8	sogefia	1	diplome	1	1000	4.932	4
1632345267	58	2019-09-04 17:43:26.266239	2019-09-04 17:50:09.331313	Ro Ki	84333919	23	mosquée sitarail	Pa Pa	49902912	21	liberté centre nord	1	sac	1	1000	1.22	3
1632345276	57	2019-09-06 11:07:37.868094	2019-09-06 12:13:50.728546	Charles N'dri 	65976495	8	Gare de bassam	Nelson Ali 	65895635	89	Alabama 	1	Documents administratifs	1	1350	19.855	3
1632345265	58	2019-09-04 12:40:46.788774	2019-09-04 17:57:47.666447	Chou Mie	59990049	29	Agban arrêt 14	Ira You	04333319	59	Aghien mosquée	2	Cartons de fripperies	1	1000	6.218	3
1632345271	1	2019-09-04 18:18:29.846134	\N	Fa Tou	22502333	4	akeikoi 2	Mi Chou	22507533	27	habitat 1	1	documents	1	1300	15.236	4
1632345268	1	2019-09-04 18:06:49.335124	2019-09-04 18:08:33.167359	htfvgg	22522522	1	gare marche	jugewu9oh	22522522	98	koumassi nord	2	chaussures	1	1500	23.253	3
1632345270	1	2019-09-04 18:13:25.482352	\N	Ami Chia	22556050	95	gare marche	Sewa Wa	22506231	105	Port bouet phare	1	documents	1	1000	5.905	4
1632345275	57	2019-09-06 11:04:30.816718	2019-09-06 12:15:28.709742	Jean louis 	64563587	115	Anyama 	Moris beats	45631567	66	Rue des banques	1	Factures	2	1450	24.464	3
1632345266	58	2019-09-04 12:52:41.807482	2019-09-06 11:00:20.931475	Bec Ky	09528997	66	Plateau, Avenue Longchamps	Ja Mi	79797875	115	Anyama carrefour IVOSEP	1	Documents administratifs	1	1450	23.338	3
1632345264	58	2019-09-04 12:19:33.813485	2019-09-06 11:04:13.739746	Jean Michel	06132315	95	krfgbnmkc,m njbdb	Gildas Koue	09539997	21	kjhgvsmnbftgyui	1	Documents	1	1250	14.195	3
1632345263	58	2019-09-04 12:14:43.606103	2019-09-06 11:05:04.786653	Chou Mie	59990049	21	adjuaiokkjhdnsm	Ira You	59020105	98	krufioprofihj	1	Documents	1	1250	14.071	3
1632345280	58	2019-09-06 11:21:34.257469	2019-09-06 11:36:51.371945	Ma Pa	75823146	115	gare taxi	Auré Lia	03642589	91	Carrefour CHU	1	Documents	1	1500	25.408	3
1632345279	58	2019-09-06 11:18:38.496434	2019-09-06 11:50:10.328089	Mi Chou	05014068	114	Bingerville, cité Késsé	Chou babe	01023548	115	Anyama carrefour IVOSEP	2	Chaussures et sacs	2	1800	36.216	3
1632345278	58	2019-09-06 11:14:45.154651	2019-09-06 11:52:45.203801	Fat Tou	57164412	65	Cité des arts, Boulevard Françcois-Mitterand Nobert, Cité Lauriers, Villa 49	Iri Na	04333319	49	cocody chateau 	1	Documents	1	1250	12.969	3
1632345281	1	2019-09-06 12:18:03.377442	2019-09-06 12:41:01.984871	Jessi Ca	01759700	66	Plateau, Rue des banques	Awa Bah	04961605	114	Bingerville, lycée garçons	1	Doucuments de bureau	1	1400	21.383	3
1632345288	58	2019-09-10 15:11:45.738771	\N	Aie aer	04992398	21	Liberté rue 1	Hein heu sien	08596512	8	Abobo Abobo 	2	Sac et écharpes	1	1300	15.106	2
1632345287	1	2019-09-10 12:18:16.36402	\N	Soualio Ouatt	02661812	3	Samaké, gare	Zerbo Oumar	56124897	102	bietry dica	2	anti choc	2	1550	23.923	2
1632345283	58	2019-09-09 12:47:29.308943	2019-09-10 14:37:01.947103	Soro	04333919	21	Liberté CIE	Aicha	09531797	66	Plateau avenue Noguès	1	Documents entreprises	1	1000	3.504	3
1632345286	58	2019-09-10 12:09:46.328114	2019-09-10 14:42:07.066696	Aicha Soro	02661812	115	Anyama, rue balsic	Behou Ba	87452365	66	Rue du commerce	1	Documents administratifs	1	1450	24.464	3
1632345282	58	2019-09-08 09:59:48.663695	2019-09-10 14:44:34.532603	fuukoij	04567900	3	t67ioojhv	étuves kk	09885543	72	Zhou gk7gl	1	vêtements	1	1300	16.719	3
1632345285	58	2019-09-10 12:06:14.652106	2019-09-10 14:46:34.957149	Sekou	04338812	85	Sable, derrière la gare	Ira You	04099753	114	Lycée Mamie fêtai 	2	Ordinateur portable	2	1550	24.837	3
1632345289	58	2019-09-19 08:58:52.636719	2019-09-19 09:29:05.847913	kouassi	59990049	47	rue 12, villa 13	soro	01475826	72	derriere sodeci	1	documents administratifs	1	1400	22.108	3
1632345296	62	2019-09-19 11:34:15.252661	\N	Niongui 	07822971	5	abobo	Aissata 	57612462	42	Rivera 	2	extrait d'acte de naissance 	2	1200	9.94	4
1632345291	62	2019-09-19 11:08:27.672465	\N	aissata	57612462	72	yopougon 	MARIAM	87610151	102	MACORY	2	CHAUSSURE	2	1500	23.601	4
1632345298	1	2019-09-19 12:33:54.564673	\N	ASSIE	57715955	20	BORRY	KOFFI	08416609	45	GOLEF	2	POLO	2	1350	15.279	2
1632345302	58	2019-09-20 09:50:32.879765	\N	kouassi	07507384	86	église ADCi	yvette	46620546	48	mosquée 	1	tee sh	1	1450	23.742	2
1632345301	58	2019-09-19 21:28:53.480518	\N	kouassi 	07507384	2	rue	kouao	42790375	19	marché 	1	chaussures 	2	1200	11.033	2
1632345300	58	2019-09-19 15:13:42.636955	\N	kouassi 	07507384	3	près boulangerie 	Amede	46620546	50	arrêt de bus	2	chaussures 	2	1450	19.569	2
1632345299	1	2019-09-19 14:57:55.632868	\N	kouassi	07507384	87	rue 2 	sako	46620546	53	rue ministre	2	vétement	2	1200	9.07	2
1632345297	58	2019-09-19 11:38:29.812702	\N	emeline	08729981	5	anerai	koffi	08729981	57	soporex	1	chaussures 	2	1100	7.237	2
1632345293	60	2019-09-19 11:08:40.945128	\N	ONAMON raphael	07822971	82	abobo	nina	79708033	21	yopougon	1	Documents administratifs	2	1200	10.903	2
1632345290	58	2019-09-19 09:02:05.711469	2019-10-08 15:53:41.924362	aicha	57999724	14	jziddkdkdlzzn	ouattara	09765432	105	vdizlsbsbzoall	1	sac et cahiers	2	1600	31.405	3
1632345294	59	2019-09-19 11:09:05.173143	2019-10-08 15:50:57.065695	BONI	49203638	8	yopougon	Valérie Oué	49203638	21	Abidjan, Abidjan	2	chaussure	1	1350	15.342	3
1632345292	61	2019-09-19 11:08:40.061714	2019-10-08 15:55:14.815511	emeline	08729981	12	ananerai	ALICE	08729981	89	ANANERAI	1	documents administratifs	2	1350	18.881	3
1632345295	59	2019-09-19 11:33:04.073158	2019-10-08 15:48:21.86316	valerie	49203638	1	abidjan	Boni	07145989	67	yopougon	1	habit	2	1300	15.296	3
1632345303	58	2019-09-20 10:20:50.469229	\N	Ai 	21545631	66	VGabakansbvs	Cha	05679824	115	Nuabsalaisahs	1	Documents administratifs 	1	1450	23.338	2
1632345304	58	2019-09-20 10:23:08.725399	\N	Mie	66548721	104	VhUjakajsbsh	Chou	51224488	87	Bajajansjsb	2	Sacs	2	1200	8.943	2
1632345321	1	2019-09-20 12:35:53.810147	\N	jakoua 	48339567	72	YOPOUGON	VAGABA	45776656	98	PLUIE MODIS	2	CHAUSSUR	2	1500	23.498	2
1632345320	1	2019-09-20 12:35:23.704125	\N	ouattara	57612462	1	A la gare	danielle	87610151	72	annaneraie	1	certificat de nationnalite	2	1300	16.152	2
1632345319	1	2019-09-20 12:35:23.395882	\N	bintou	08223240	19	adjame	mariam	55601020	3	abobo	2	vetments	2	1250	12.268	2
1632345328	62	2019-09-23 11:12:28.650519	\N	ouattara aissata	57612462	82	yopougon 	MARIAM coulibaly	87610151	21	liberté	2	micro onde	1	1250	10.903	2
1632345322	1	2019-09-20 12:36:13.410629	2019-09-20 12:37:46.063292	ASSIE	08416609	23	DALLAS	YAO	57715955	6	ZOO	2	CHEMISE	2	1200	8.837	4
1632345318	1	2019-09-20 12:35:03.597178	\N	kouassi	07507384	24	rue 23	yobouet	46620546	57	rue 10	2	une valise	2	1200	9.853	2
1632345306	58	2019-09-20 11:08:13.438964	2019-09-20 11:34:35.803853	Soro	58642483	98	Bhahsnsjns	Aicha	08575236	95	Bahnssnkaka	2	Chaussures 	1	1000	1.67	3
1632345307	58	2019-09-20 11:11:51.600665	2019-09-20 11:34:36.618677	Blaise	08562485	82	Bjshjssjb	Pascal	08965214	8	Ganiashshshsb	1	Documents administratifs 	1	1450	23.219	3
1632345308	58	2019-09-20 11:17:04.679647	2019-09-20 11:34:42.302094	Ira	06524897	21	Bahjaansbsb	You	57461320	105	Naisksnsj	2	Sac	1	1300	14.204	3
1632345309	58	2019-09-20 11:20:59.675476	2019-09-20 11:34:48.937267	Chou	98563128	22	Hiansbsjoa	Mie	08524897	70	Balisevsve	2	Portable	1	1500	22.419	3
1632345310	58	2019-09-20 11:24:10.583493	2019-09-20 11:34:52.007423	Brandy	05431512	28	JzhHajsbv	Cute 	57246434	66	Bajajahssh	1	Documents bureau 	1	1150	7.591	3
1632345305	58	2019-09-20 10:24:54.525998	2019-09-20 11:34:54.315478	Cedric	08597541	65	Haajsbvssb	Jean	59875421	39	Habsksksnsb	1	Extrait de naissance 	1	1150	9.094	3
1632345327	1	2019-09-23 11:10:32.034585	\N	ASSIE YAO ISIDORE	48561803	20	BORRY	GRACE	49096306	48	asd	2	ordinateur hp	1	1300	14.779	2
1632345346	1	2019-09-24 14:05:59.298198	2019-09-25 15:38:06.319796	kouassi	07507384	76	rue 2	franck	46620546	78	rue 32	2	chaussure	1	1500	23.019	3
1632345314	58	2019-09-20 11:51:18.033524	\N	Assie	48561803	66	Plateau 	Koffi	57715955	66	Plateau 	2	Chapeau 	1	1000	0	2
1632345312	60	2019-09-20 11:49:14.24072	2019-09-25 12:38:21.005029	jocelyne	07822971	102	marcory	jonathan	77925469	90	treichville	1	Documents administratifs	1	1000	5.32	3
1632345331	64	2019-09-23 14:32:43.018101	2019-09-23 14:43:07.270531	kouassi	07507384	65	rue 13	fredy	46620546	46	rue marché	1	factures	2	1100	7.032	3
1632345323	64	2019-09-20 14:57:19.912426	2019-09-20 15:02:58.233879	kouassi	07507384	65	rue 21	florence	46620546	61	grand marché	2	article scolaire	2	1000	2.37	3
1632345316	58	2019-09-20 11:56:29.488755	2019-09-20 15:03:09.433318	kouassi	07507384	37	rue	soro	46620546	114	rue	1	chaussures 	1	1350	19.392	3
1632345324	1	2019-09-20 16:02:58.682003	\N	assie	48561803	30	BORRY	ANGE	59061314	35	SDE	2	HP	2	1000	4.789	2
1632345325	62	2019-09-20 16:24:45.385224	\N	aissata	57612462	72	annaneraie	danielle	87610151	102	MACORY	2	sac a main	2	1500	23.601	2
1632345332	58	2019-09-24 10:47:42.685819	\N	Assie	48561803	66	Borry	Kouakou	57715955	22	Sable 	2	Chaussures 	1	1000	1.594	2
1632345315	58	2019-09-20 11:52:24.639958	2019-09-25 13:49:14.494939	FRANKY	08729981	70	YOP	EMELINE	08729981	72	YOP	2	CHAUSSUR	2	1200	8.919	3
1632345340	58	2019-09-24 13:56:08.083082	2019-09-24 14:02:59.885073	Traore	49111095	8	Sogefia	Bamba	05872487	115	Mosquée 	2	Montre 	2	1250	11.944	3
1632345333	59	2019-09-24 10:47:43.22701	\N	OUE	49203638	8	yopougon	DAH	09876543	70	Abidjan, Abidjan	1	EXTRAIT	1	1550	28.065	2
1632345330	59	2019-09-23 11:14:35.846232	\N	sofia	49203638	105	abobo	Valérie Oué	49203638	8	Abidjan, Abidjan	1	montre	2	1550	27.831	2
1632345329	1	2019-09-23 11:12:40.37127	\N	dibgeutine	49494906	11	deux cocotier	digbeu	48484807	32	carrefour adjoua	2	pagne	2	1400	18.911	2
1632345334	60	2019-09-24 10:49:35.726823	\N	franck	07507384	65	rue 12	joce	46620546	105	centre pilote	2	Chaussures et sacs	2	1400	18.457	2
1632345335	62	2019-09-24 10:54:07.010053	\N	KOUASSI	09100683	8	SOGEPHIA	SORO	56411473	65	ANGRE	1	CASIER JUDICIAIRE	2	1200	10.26	2
1632345348	1	2019-09-24 14:08:37.591101	2019-09-25 12:39:08.498953	AICHA	57612462	95	Remblais	Daniel	87610151	101	Zone 4C	2	Iphone 7	2	1000	2.991	3
1632345336	58	2019-09-24 12:09:39.386033	2019-09-24 12:28:30.785973	Dhssnskk	08546987	21	Jzjsjsbsb	Jsjshvssb	08526482	95	Jausjasn 	2	Sac	1	1250	11.043	3
1632345337	58	2019-09-24 12:14:47.917866	2019-09-24 12:28:34.35072	Jsbsvssgv	05648208	21	Jvaagaia	Kabahsjasj	59631421	66	Jabahshwnwj	1	Extrait	1	1000	3.504	3
1632345338	58	2019-09-24 12:18:20.490501	2019-09-24 12:28:38.631963	Stsvsie	08563128	28	Rehebeoak	Dajsmskjs	05123694	8	Baissnnh	2	Chaussures 	1	1200	10.659	3
1632345339	58	2019-09-24 12:21:21.737991	2019-09-24 12:28:39.932229	Hzisjsb	08531265	29	Nishsvd	Jajsbvsshau	08523187	65	Jejeowkecehej	2	Sacs	1	1000	6.438	3
1632345313	62	2019-09-20 11:49:18.787517	2019-09-24 13:27:55.962934	Ouattara	57612462	12	agbekoi	MARIAM	87610151	115	anyama	2	portable marque iphone	2	1200	10.801	3
1632345317	1	2019-09-20 12:34:40.309182	2019-09-24 13:42:15.952929	boni	07145989	1	ABOBO	NEARIA	03246658	8	ABOBO	1	EXTRAIT	1	1000	3.683	3
1632345341	60	2019-09-24 13:56:52.445365	2019-09-24 14:03:03.69872	Konan	87425935	93	Treichville, CHU	KONATE	08170994	102	Marcory, Biétry	2	Cartons de fripperies	2	1000	4.686	3
1632345342	1	2019-09-24 13:57:08.114608	2019-09-24 14:03:18.07454	kouassi	07507384	76	rue 2	franck	46620546	78	rue 32	2	chaussure	1	1500	23.019	3
1632345326	1	2019-09-23 09:06:09.88075	2019-09-25 13:49:11.379613	ASSIE 	57715955	20	BORRY	NICKA	59061324	76	QTE	2	ROBE	1	1300	13.109	3
1632345343	59	2019-09-24 13:57:38.86125	2019-09-24 14:03:00.103173	assoukpou	07678980	65	cocody	afoue	22102900	114	bingerville	2	montre	1	1450	20.596	3
1632345344	62	2019-09-24 13:57:47.003145	2019-09-24 14:03:00.579876	ACHIMA	40106527	66	st-michel	GOULI	56411473	66	sorbone	1	extrait	1	1000	0	3
1632345345	59	2019-09-24 13:59:34.732452	2019-09-25 13:45:21.717895	yao	09876543	2	abobo	marie	08987665	4	abidjan	1	montre	2	1150	8.446	3
1632345311	59	2019-09-20 11:49:07.962039	2019-09-27 16:10:18.430955	boni	49203638	105	abobo	Valérie Oué	49203638	112	Abidjan, Abidjan	2	chaussure	1	1400	19.394	3
1632345350	1	2019-09-24 14:09:05.355654	2019-09-25 13:41:56.272503	bamba	09275257	1	abobo	kouassi	05872487	115	anyama	1	document	2	1200	10.369	3
1632345349	1	2019-09-24 14:08:43.610014	2019-09-27 10:28:37.36776	ADOU	08765432	66	sorbonne	line	09345678	66	cite administrative	2	montre	2	1000	0	3
1632345351	1	2019-09-24 14:32:11.253562	2019-09-24 14:41:08.965897	bamba	09275257	66	plateau	kouassi	05872487	66	plateau	2	colis	2	1000	0	3
1632345347	1	2019-09-24 14:07:54.607672	2019-09-25 09:20:56.914235	marie	22302335	41	ABIDJAN	DOMI	05660707	60	ABIDJAN	1	EXTRAIT	2	1200	11.004	3
1632345352	1	2019-09-24 14:33:38.476763	2019-09-24 14:40:04.382319	kouakou	09275257	65	2 plateaux	kouassi	05872487	37	cocody	2	colis	2	1150	7.103	3
1632345382	1	2019-09-25 12:51:33.191963	\N	Didier	22222222	94	danga	Didier	22222222	38	Val Doyen 1	2	montre	1	1300	15.088	2
1632345353	1	2019-09-24 15:26:10.765461	\N	MARIE	44051228	2	rue 	Chalotte	02441233	102	rue	1	Document	2	1400	21.949	4
1632345374	1	2019-09-25 11:33:56.345743	2019-09-25 11:38:16.455365	didier	40106527	39	ambassade	sonia	06251948	92	cité du personnel	2	sac de banane	2	1250	11.451	3
1632345354	1	2019-09-24 15:31:02.310543	\N	Mariam	02311100	2	rue	sophie	01110203	102	rue	2	Vetements	2	1500	21.949	4
1632345355	1	2019-09-24 15:38:21.69044	\N	Picherie	02131452	17	rue	choupi	05121011	67	rue	2	sac a main	1	1400	18.921	2
1632345356	62	2019-09-24 16:13:01.671351	\N	aissata	57612462	20	djeni kobenan	MARIAM coulibaly	87610151	72	annanéraie	2	CHAUSSURE	1	1250	11.983	2
1632345377	1	2019-09-25 11:34:55.251482	2019-09-25 11:38:19.432822	DAO	24785676	1	la gare	SOLA	57875640	54	blockhauss	2	un telephone cellulaire	1	1350	16.048	3
1632345370	1	2019-09-25 11:13:23.240946	\N	OUE	23456789	66	PLATEAU	OUATTARA	56676554	115	Anyama	1	Extrait	2	1450	23.338	2
1632345357	1	2019-09-24 16:27:36.029092	2019-09-24 16:34:43.898677	Marie	77802031	88	rue	gisele	01232450	102	rue	2	vetements	1	1150	8.216	3
1632345358	64	2019-09-25 09:11:20.676008	\N	Janam	07507384	59	galerie santa maria	séphora	46620546	70	église AD	1	diplome	2	1500	26.058	2
1632345359	64	2019-09-25 09:25:42.971011	\N	Arlette	07507384	39	rue 25	Ema	46620546	8	poubelle	2	habit	1	1400	17.544	2
1632345360	62	2019-09-25 10:09:32.620281	\N	Konan	40106527	8	SOGEPHIA	GOULI	87610151	66	plateau	2	micro onde	1	1400	17.913	2
1632345369	1	2019-09-25 11:13:13.623338	\N	KONE	87425935	98	LE MICHIGAN	KONATE	42704758	66	PLATEAU	2	SAC A POUBELLE	1	1200	9.217	2
1632345361	1	2019-09-25 10:23:38.658834	\N	kouassi	09100683	1	abobo	koffi	40106527	66	st-michel	1	certificat de nationnalité	1	1300	15.453	2
1632345363	64	2019-09-25 10:47:57.564389	\N	assoumou	48484809	82	ananerai	ALICE	48484807	21	ANANERAI	2	habit	2	1250	10.903	2
1632345375	1	2019-09-25 11:34:02.546887	2019-09-25 11:38:20.336241	VALRIE	23456789	66	PLATEAU	OPPORTUNE	56676554	115	Anyama	2	PORTABLE	1	1500	23.338	3
1632345362	1	2019-09-25 10:47:49.35801	\N	konan	87425935	87	centre	KONATE	42704758	105	Abattoir	2	CHAUSSURE	1	1200	9.644	2
1632345376	1	2019-09-25 11:34:11.827386	2019-09-25 11:38:39.12476	GUY	42704758	94	SICOGI	ROGER	87425935	66	PLATEAU	2	CHAUSSURE	2	1300	13.242	3
1632345387	59	2019-09-25 14:46:39.451141	2019-09-25 15:00:45.907616	kouassi	09778341	21	macaci	RUTH	09254325	28	adjamé	2	montre	2	1000	2.056	3
1632345365	1	2019-09-25 10:49:30.375457	2019-09-25 10:50:51.040088	oue	12223455	66	PLATEAU	OUATTARA	57622462	66	PLATEAU	2	MONTRE	1	1000	0	3
1632345364	1	2019-09-25 10:48:46.286123	2019-09-25 10:53:03.435183	sonia	06251948	38	FAYA	DIDIER	40106527	46	FAYA	2	chaussures	2	1000	4.813	3
1632345366	1	2019-09-25 10:49:58.749198	2019-09-25 10:53:55.838535	beda	6485786_	1	la gare	konon	85784585	2	anadore	1	extrait	2	1000	2.626	3
1632345378	60	2019-09-25 12:15:28.502991	2019-09-25 12:20:28.209059	Konan	42704758	98	koumassi le Michigan	SORO MARIAM IRAYOU	87452365	102	Bietry	2	Cartons de fripperies	2	1000	3.847	3
1632345367	1	2019-09-25 11:02:23.792018	\N	KONANA	87425935	95	REMBLAIS	KONATE	87425935	107	GONZAGUEVILLE	2	IPHONE	1	1300	15.185	2
1632345371	1	2019-09-25 11:14:29.450328	2019-09-25 11:29:38.520954	didier	40106527	40	MERMOZ	sonia	06251948	90	ARRAS 3	1	EXTRAIT DE NAISSANCE	1	1150	9.293	3
1632345372	1	2019-09-25 11:14:54.759657	2019-09-25 11:29:43.079349	doumbia	24785674	1	la gare	kouma	57875642	54	blockhauss	2	un ordinateur	2	1350	16.048	3
1632345373	1	2019-09-25 11:21:32.552509	2019-09-25 11:32:59.850732	OUE	23456789	66	PLATEAU	OUATTARA	56676554	115	Anyama	1	Extrait	2	1450	23.338	3
1632345383	1	2019-09-25 13:39:00.13356	\N	kouacou	09275257	60	cocody	Ruth	77783408	6	ABOBO	2	sac à main	2	1000	4.25	2
1632345379	1	2019-09-25 12:23:23.10464	\N	bea	56411473	59	aghien	bile	40106527	93	chu	1	extrait	2	1250	13.651	2
1632345390	59	2019-09-25 15:05:02.524494	2019-09-25 15:11:58.409809	BRICE	23457654	21	ADJAME	OTHNIEL	21341234	65	COCODY	2	chaussure	2	1200	9.089	3
1632345380	1	2019-09-25 12:32:29.808175	\N	didier	40106527	42	riviéra 2	konan	56411473	102	biétry	2	montre	1	1200	10.334	2
1632345368	1	2019-09-25 11:08:05.340379	2019-09-25 12:37:14.920155	KONAN	87425935	95	REMBLAIS	KONON	42704758	94	SICOGI	2	10	1	1000	2.102	3
1632345381	1	2019-09-25 12:43:19.863573	2019-09-25 12:44:54.510142	bamba	22222222	94	sicogi nord est	barry	88664477	98	Le Michigan	1	casier judiciaire	1	1000	4.149	3
1632345396	1	2019-09-25 15:23:02.41146	2019-09-25 15:37:07.226425	DOMI	90987654	4	ABOBO	NéNé	36875849	96	KOUMASSI	2	TAPIS	2	1600	28.165	3
1632345384	1	2019-09-25 14:44:58.604346	2019-09-25 14:56:54.803092	Die	22341250	95	Remblais	Yann	08534567	98	Le Michigan	2	Montre	2	1000	1.67	3
1632345385	1	2019-09-25 14:45:54.835458	2019-09-25 14:58:25.480785	sonia	06251948	39	COCODY	opportune	58597015	45	COCODY	2	SAC A MAIN	1	1250	12.947	3
1632345389	1	2019-09-25 15:02:46.109101	2019-09-25 15:11:54.619889	judith	97888900	38	COCODY	ANNE	85868756	94	KOUMASSI	2	BARRE	1	1300	13.49	3
1632345388	1	2019-09-25 15:01:41.684095	2019-09-25 15:11:58.041012	Die	20142014	95	Remblais	bobodiouf	20192019	25	Sodeci	2	CHAUSSURE	2	1350	15.785	3
1632345393	59	2019-09-25 15:18:14.25204	\N	KAR	98876709	65	SAINT JEAN	LOI	67754334	98	Abidjan, Abidjan	1	EXTRAIT	1	1300	15.675	2
1632345392	1	2019-09-25 15:18:11.208936	\N	DOMI	90987654	4	ABOBO	NéNé	36875849	96	KOUMASSI	2	TAPIS	2	1600	28.165	4
1632345391	1	2019-09-25 15:16:53.922335	2019-09-25 15:37:19.406259	Souké	20192019	94	Sicogi	Siriki	20182018	9	Plaque	2	Montre	2	1550	25.547	3
1632345395	1	2019-09-25 15:22:15.401134	2019-09-25 15:37:57.831658	SOU	87654326	37	YOPOUGON	JAN	56456787	73	ABIDJAN	1	BAC	1	1300	15.756	3
1632345394	64	2019-09-25 15:19:04.809894	2019-09-25 15:36:59.30835	fernande	88701100	82	abobo doume	lea	07822971	65	2plateau	2	vetements	2	1450	19.91	3
1632345398	1	2019-09-25 15:47:01.115289	2019-09-25 15:56:05.94341	souké	09998980	1	ABOBO	baba	03232345	98	KOUMASSI	1	TISSU	1	1450	23.253	3
1632345402	64	2019-09-25 15:54:04.938448	2019-09-25 15:59:33.269193	joce	07822971	82	abobo doume	falonne	45256521	65	2plateaux	2	vetements	2	1450	19.91	3
1632345401	1	2019-09-25 15:51:19.737416	\N	Konan	44444444	96	port-bouet 2	Bamba	00000000	7	Baoulé	2	brosse	2	1400	19.374	2
1632345397	1	2019-09-25 15:46:23.905136	2019-09-25 15:55:57.107209	Konan	44444444	96	port-bouet 2	Bamba	00000000	7	Baoulé	2	brosse	2	1400	19.374	3
1632345400	59	2019-09-25 15:49:37.600969	2019-09-25 15:58:50.114978	ASSIE	57715955	65	2plateau	YAO	48561803	82	Abidjan, Abidjan	2	chaussure	2	1450	21.635	3
1632345399	64	2019-09-25 15:48:45.164345	2019-09-25 16:28:11.491591	joce	02255690	82	abobo doume	falonne	02221100	65	2plateaux	2	vetements	2	1450	19.91	3
1632345386	64	2019-09-25 14:46:18.765106	2019-09-27 16:10:15.074756	joce	07822971	105	abattoir	jonathan	77928040	113	aeroport	1	extrait	2	1150	8.544	3
1632345432	58	2019-09-26 15:20:28.504377	\N	kk	07507384	1	boulangerie 	mm	04568757	103	espace de jeux	2	lunettes 	2	1450	20.041	2
1632345424	1	2019-09-25 16:58:04.822044	2019-09-25 17:16:02.771433	othniel	12324312	39	COCODY	BENEDICTE	49111095	93	TREICHVILLE	2	MONTRE	1	1200	10.52	3
1632345425	1	2019-09-25 16:58:57.357606	2019-09-25 17:16:07.012788	sabine	21221340	68	rue12	ghislain	44231010	95	rue23	1	extrait	1	1350	19.014	3
1632345426	1	2019-09-25 16:59:12.175116	2019-09-25 17:17:06.066678	drissa	09834456	2	ABOBO	vadoumana	08506670	71	YOPOUGON	2	TREHIS	1	1450	21.536	3
1632345423	1	2019-09-25 16:57:22.806566	2019-09-25 17:18:00.420742	KOUMASSI	11111111	94	Sicogi nord est	Cocody	22222222	40	Mermoz	1	fer à beton	2	1250	14.84	3
1632345418	59	2019-09-25 16:43:06.798267	2019-09-25 17:18:26.208566	LAR	34567890	57	Abidjan	HOU	34567890	70	Abidjan, Abidjan	2	montre	1	1550	25.76	3
1632345417	1	2019-09-25 16:40:59.320385	2019-09-25 16:46:44.589919	papitou	09877654	4	ABOBO	VIEUX	78652447	89	TREICHVILLE	2	GHY	1	1500	23.369	3
1632345412	1	2019-09-25 16:09:40.187925	\N	DAH	23456543	3	ABOBO	JAK	57890976	75	YOPOUGON	1	TRIS	1	1300	15.637	2
1632345413	64	2019-09-25 16:10:14.45223	\N	mamie	08291225	72	rue22	lea	01133560	65	rue20	1	article scolaire	1	1300	15.088	2
1632345421	1	2019-09-25 16:44:19.539338	2019-09-25 16:46:50.545711	ADJA	09877654	115	ABOBO	TANIA	78652447	102	MARCORY	2	GANTS	1	1700	32.367	3
1632345406	1	2019-09-25 16:04:52.582576	2019-09-25 16:11:40.70593	JEAN	23456543	3	ABOBO	JUDITH	57890976	91	TREICHVILLE	1	PATTE	1	1300	16.964	3
1632345410	1	2019-09-25 16:06:35.737056	2019-09-25 16:11:44.553215	RUTH	12345432	37	COCODY	BRICE	54321232	100	marcory	2	portable	2	1150	8.564	3
1632345433	62	2019-09-26 16:05:36.581047	2019-09-26 16:25:56.965712	assie	48561803	22	adj	danielle	57715955	66	ABIDJAN	2	portable marque iphone	1	1000	1.719	3
1632345404	1	2019-09-25 16:04:30.565379	2019-09-25 16:16:24.582356	koumassi	22222222	94	SICOGI	Abobo	11111111	18	n'dotré	1	extrait de naissance	1	1700	35.672	3
1632345405	1	2019-09-25 16:04:32.938827	2019-09-25 16:16:36.881608	RUTH	12345432	37	COCODY	BRICE	54321232	115	anyama	1	extrait	2	1450	22.548	3
1632345409	64	2019-09-25 16:05:50.496431	2019-09-25 16:21:54.210451	jona	07822971	72	ananeraie	kouadio	22335420	96	port bouet	2	vetements	2	1500	22.436	3
1632345411	64	2019-09-25 16:08:21.350436	2019-09-25 16:23:18.77197	josiane	22492312	73	rue12	caro	22503116	115	rue20	1	extrait	1	1400	21.341	3
1632345414	1	2019-09-25 16:12:18.546874	2019-09-25 16:28:02.447627	DIJ	23456543	3	ABOBO	JETLI	57890976	45	COCODY	1	ATRES	1	1450	22.898	3
1632345403	1	2019-09-25 16:03:46.833119	2019-09-25 16:28:06.908175	koumassi	22222222	94	SICOGI	Cocody	11111111	45	Riviera 5	1	extrait de naissance	1	1400	21.731	3
1632345407	1	2019-09-25 16:05:03.728111	2019-09-25 16:29:04.954438	koumassi	22222222	94	SICOGI	yopougon	11111111	75	banco nord	1	extrait de naissance	1	1500	26.719	3
1632345408	1	2019-09-25 16:05:46.809803	2019-09-25 16:29:14.792798	RUTH	12345432	37	COCODY	BRICE	54321232	85	yopougon	2	montre	2	1250	11.268	3
1632345427	58	2019-09-26 14:16:01.422329	\N	rosé 	23371818	48	rue 45	tych	01010101	4	rue des grâces	1	veste	1	1500	27.46	2
1632345428	1	2019-09-26 14:16:50.303602	2019-09-26 14:21:57.702227	ARIELLE	22222222	67	12	AUDREY	11111111	90	rue5	2	PAGNES	2	1300	15.167	4
1632345419	1	2019-09-25 16:43:22.52013	\N	marie	21003344	67	rue12	ange	23210040	37	rue2	2	chaussures	1	1300	13.564	4
1632345415	1	2019-09-25 16:40:14.995836	2019-09-25 16:47:54.1847	KOUMASSI	11111111	94	SICOGI	ABOBO	22222222	6	ZOO	2	CHAUSSURE	1	1450	20.12	3
1632345416	1	2019-09-25 16:40:50.023012	2019-09-25 16:48:00.78767	KOUMASSI	11111111	94	SICOGI	ABOBO	22222222	115	Anyama	2	CHAUSSURE	1	1800	35.644	3
1632345420	1	2019-09-25 16:44:17.29544	2019-09-25 16:51:34.711734	Marie	21003344	67	rue12	ange	23210040	37	rue2	2	chaussures	1	1300	13.564	3
1632345422	1	2019-09-25 16:46:43.678984	2019-09-25 16:51:40.395681	adja	88221311	68	rue12	raissa	03122015	39	rue2	2	chaussures	2	1300	13.992	3
1632345440	65	2019-09-27 11:07:59.455061	2019-09-27 11:11:29.752728	konan	87425935	57	Abbri 2000	SORO	11111111	94	Sicogi	2	micro onde	2	1300	13.572	3
1632345434	1	2019-09-26 17:17:59.497025	2019-09-26 17:37:00.882241	ppp	07507384	1	rue2	mmmm	46620546	115	mosquée centrale	1	sac	1	1200	10.369	3
1632345429	1	2019-09-26 14:25:25.291682	2019-09-26 14:31:40.395303	ARIELLE	22222222	95	12	AUDREY	77777777	94	12	2	CHAUSSURES	2	1000	2.102	3
1632345430	1	2019-09-26 14:40:12.394645	\N	oyo	07777777	71	AD	gao	46620546	9	mosqué	2	SAC DE VOYAGE	1	1550	24.792	2
1632345431	1	2019-09-26 14:59:01.80324	\N	oyo	46620546	69	rue carre	gao	3654565_	9	maquis 225	2	habit	2	1650	29.459	2
1632345443	59	2019-09-27 11:09:24.047082	2019-09-27 11:14:59.900408	JAR	45678909	66	RUE 45	MAR	45765678	8	botoboto	1	EXTRAIT	1	1300	16.715	3
1632345448	1	2019-09-27 11:20:18.01273	2019-09-27 11:25:00.506065	VERO	00000000	7	RUE0	ANGE	66666666	40	RUE8	2	CHEMISES	1	1250	12.379	3
1632345438	1	2019-09-27 10:55:12.492505	2019-09-27 10:58:14.870676	landry	12321234	94	kouassi	ruth	12098765	90	treichville	2	montre	2	1200	9.337	3
1632345435	65	2019-09-27 10:49:31.770992	2019-09-27 10:59:32.469945	konan	87425935	65	2 plateau	Bamba	11111111	61	ANGRE	2	sac a main	2	1000	2.37	3
1632345436	59	2019-09-27 10:52:39.069598	2019-09-27 10:59:46.93929	LAR	34567689	66	Plateau	SOU	87654567	66	RUE34	2	MECHE	2	1000	0	3
1632345437	1	2019-09-27 10:54:14.346445	2019-09-27 11:02:55.635143	marie	11111111	5	RUE21	francine	22222222	8	rue2	1	documents	2	1150	7.697	3
1632345439	1	2019-09-27 10:57:44.320526	2019-09-27 11:03:00.206114	marie	11111111	5	RUE3	FRANCINE	22222222	8	RUE3	1	DOCUMENTS	2	1150	7.697	3
1632345441	1	2019-09-27 11:08:01.419831	2019-09-27 11:11:13.485826	landry	92866903	94	koumassi	Opportune	12324312	43	cocody	2	lit	2	1350	17.357	3
1632345442	1	2019-09-27 11:08:39.462381	2019-09-27 11:16:54.311034	BLANDINE	77777777	7	RUE9	SYLVIE	66666666	66	RUE5	2	VETEMENTS	2	1400	19.134	3
1632345447	65	2019-09-27 11:19:56.160397	2019-09-27 11:22:28.745505	Konan	87425935	59	AGHIEN	OUE	11111111	66	plateau	1	CASIER JUDICIAIRE	1	1200	10.695	3
1632345446	59	2019-09-27 11:19:45.730471	2019-09-27 11:25:18.647982	LOU	34567689	66	RUE 45	MAR	87654567	98	RUE34	2	MECHE	1	1200	9.236	3
1632345444	68	2019-09-27 11:14:56.945317	2019-09-27 11:20:20.449627	amenan	08729981	21	portorportor	ZONGO	49494909	28	placali	2	BROSSE	2	1000	2.056	3
1632345449	1	2019-09-27 11:29:40.844389	2019-09-27 11:40:11.23189	Othniel	21432157	94	koumassi	Luc	54936959	66	plateau	1	livre	2	1250	13.242	3
1632345445	1	2019-09-27 11:19:26.087376	2019-09-27 11:23:48.054762	paul	12321234	94	koumassi	jean	98986900	7	abobo	2	stylo	2	1550	24.368	3
1632345452	1	2019-09-27 11:30:39.366776	2019-09-27 11:34:55.344322	melissa	44444444	6	RUE5	RAOUL	66666666	41	RUE1	2	CHAPEAUX	1	1250	11.624	3
1632345451	1	2019-09-27 11:30:20.182988	\N	Othniel	21432157	94	koumassi	Luc	54936959	23	adjamé	2	montre	2	1450	20.8	2
1632345454	59	2019-09-27 11:31:14.340231	\N	MAR	45678909	66	RUE 45	GOU	45678909	8	botoboto	2	MECHE	1	1350	16.715	2
1632345450	65	2019-09-27 11:30:03.281164	2019-09-27 11:33:57.466609	Konan	87425935	59	Aghien	koumassi	11111111	96	port bouet	2	CHAUSSURE	1	1300	14.396	3
1632345509	1	2019-09-27 14:43:22.001331	2019-09-27 14:57:06.876127	KOI	56767898	66	OIU	JOI	34343467	6	JKO	1	BAC	1	1200	11.449	3
1632345453	65	2019-09-27 11:31:11.810246	\N	konan	87425935	65	AGHIEN	adjame	11111111	21	libeté	2	CHAUSSURE	2	1150	8.686	2
1632345456	59	2019-09-27 11:32:57.39792	\N	KOU	45678909	66	RUE89	JOU	90098776	98	RUE5	1	EXTRAIT	1	1150	9.236	2
1632345455	1	2019-09-27 11:32:34.771032	2019-09-27 11:34:47.046269	melissa	44444444	6	RUE5	NINA	66666666	94	RUE1	2	CHAPEAUX	1	1350	16.767	3
1632345492	1	2019-09-27 14:17:18.99484	\N	konan	11111111	37	danga	konan	11111111	100	LIBERTE	2	CHAUSSURE	1	1150	8.564	2
1632345483	1	2019-09-27 14:12:14.379556	2019-09-27 14:25:03.657492	luv	12345678	94	koumassi	jean	22331545	15	abobo	1	livre	2	1600	31.438	3
1632345471	1	2019-09-27 12:05:45.891331	\N	NOU	67875654	66	RUE45	GOU	78986775	4	BOTO	1	EXTRAIT	1	1400	20.229	2
1632345494	1	2019-09-27 14:34:46.172341	\N	ASSIE	22232425	20	SKO	ASSI	23242526	100	KKK	2	MONTRE	1	1250	10.912	4
1632345475	1	2019-09-27 12:06:57.90629	\N	OI	09897898	66	RUE98	LOI	09876545	95	BOIM	2	MONTRE	1	1200	8.858	2
1632345466	1	2019-09-27 11:53:45.560174	\N	melissa	44444444	6	RUE5	NINA	66666666	64	RUE1	2	CHAPEAUX	1	1200	8.772	2
1632345465	59	2019-09-27 11:53:22.730331	\N	HAU	09898767	66	RUE 45	DOU	45678789	8	botoboto	2	MONTRE	1	1350	16.715	2
1632345463	1	2019-09-27 11:51:57.710805	2019-09-27 11:54:36.262728	luc	13455666	94	koumassi	jean	14667776	55	cocody	2	riz	2	1400	17.443	3
1632345490	1	2019-09-27 14:14:07.163929	2019-09-27 14:26:34.636362	assie	57715955	20	DALLAS	SALLA	48561803	114	BN	2	CHAUSSURE	1	1450	21.122	3
1632345461	65	2019-09-27 11:51:46.477236	2019-09-27 11:55:12.284119	KONAN	87425935	46	Anono	koumassi	11111111	94	Sicogi	2	sac a main	1	1200	10.296	3
1632345458	1	2019-09-27 11:51:03.120701	2019-09-27 11:56:11.282869	melissa	44444444	6	RUE5	NINA	66666666	64	RUE1	2	CHAPEAUX	1	1200	8.772	3
1632345462	59	2019-09-27 11:51:46.89716	2019-09-27 11:57:02.699268	KOU	56789876	66	RUE 45	SOU	56764567	98	RUE34	2	MECHE	1	1200	9.236	3
1632345467	1	2019-09-27 11:57:14.158556	\N	sylvie	77777777	1	RUE7	SYLVIE	99999999	66	RUE5	2	FOULARD	1	1350	15.453	2
1632345489	1	2019-09-27 14:13:43.207181	2019-09-27 14:27:20.013047	mi	23232323	3	rue 1	PI	00000000	26	rue6	1	DIPLOME	1	1000	6.67	3
1632345459	1	2019-09-27 11:51:28.124882	2019-09-27 11:59:34.02952	luc	13455666	94	koumassi	jean	14667776	66	plateau	2	montre	1	1300	13.242	3
1632345457	1	2019-09-27 11:43:30.377925	2019-09-27 12:00:21.428216	kkk	45454567	20	RUE 5	JJJJ	07070707	6	RUE 4	1	DIPLOME	1	1000	6.488	3
1632345460	1	2019-09-27 11:51:39.831374	2019-09-27 12:00:36.220799	konan	22222222	37	DANGA	PLATEAU	22222222	66	plateau	2	chaussure	1	1000	4.845	3
1632345488	1	2019-09-27 14:13:37.432146	2019-09-27 14:27:24.828998	FOU	89098767	66	POI	JOU	5687787_	25	YUI	1	EXTRAIT	1	1000	4.987	3
1632345505	1	2019-09-27 14:41:18.847786	2019-09-27 14:45:03.331314	KOI	56767898	66	OIU	JOI	34343467	114	JKO	1	BAC	1	1400	21.383	3
1632345469	1	2019-09-27 12:05:12.164499	2019-09-27 12:09:58.284655	KONAN	00000000	37	danga	koumassi	00000000	94	sicogi	2	chaussure	1	1250	11.249	3
1632345473	65	2019-09-27 12:06:16.436056	2019-09-27 12:10:21.76326	konan	87425935	65	2 plateaux	Adjamé	11111111	21	liberté	2	CHAUSSURE	1	1150	8.686	3
1632345468	1	2019-09-27 12:05:08.156281	2019-09-27 12:10:27.195135	CARO	77777777	1	RUE7	RAISSA	99999999	63	RUE5	2	VESTE	1	1250	11.305	3
1632345481	1	2019-09-27 14:11:36.535502	2019-09-27 14:22:49.857823	MOU	34567898	66	RES	VOU	89875678	90	HUY	1	EXTRAIT	1	1000	4.773	3
1632345474	1	2019-09-27 12:06:21.911818	2019-09-27 12:11:38.921661	lub	55455655	94	koumassi	luc	23466777	66	plateau	1	livre	1	1250	13.242	3
1632345476	1	2019-09-27 12:07:51.587495	2019-09-27 12:11:49.225052	RAPHAEL	77777777	1	RUE7	RAISSA	99999999	66	RUE5	2	VESTE	1	1350	15.453	3
1632345464	59	2019-09-27 11:53:17.802339	2019-09-27 12:12:17.866393	HAU	09898767	66	RUE 45	DOU	45678789	8	botoboto	2	MONTRE	1	1350	16.715	3
1632345472	1	2019-09-27 12:06:10.461892	2019-09-27 12:13:08.993853	assie	11111111	20	SZA	ZAE	22222222	5	STR	2	CHAUSSURE	1	1000	4.578	3
1632345477	1	2019-09-27 12:07:55.279445	2019-09-27 12:13:52.64015	assie	11111111	21	SDF	ZAE	22222222	45	STR	2	CHAUSSURE	1	1300	13.931	3
1632345470	1	2019-09-27 12:05:42.977371	2019-09-27 12:17:05.373428	lub	55455655	94	koumassi	lou	23466777	26	adjamé	1	livre	1	1350	19.815	3
1632345480	1	2019-09-27 14:11:35.9357	2019-09-27 14:22:56.72234	mi	23232323	3	rue 1	chou	00000000	102	rue6	1	DIPLOME	1	1450	23.923	3
1632345493	1	2019-09-27 14:24:27.006518	2019-09-27 14:27:30.22375	konan	11111111	37	DANGA	konan	11111111	25	SODECI	2	CHAUSSURE	1	1150	8.284	3
1632345482	1	2019-09-27 14:11:49.029527	2019-09-27 14:28:14.831901	luv	12345678	94	koumassi	jean	22331545	114	bingerville	1	livre	2	1550	27.574	3
1632345478	1	2019-09-27 14:11:15.158572	2019-09-27 14:23:01.871413	konan	11111111	37	danga	konan	11111111	100	CENTRE	2	CHAUSSURE	1	1150	8.564	3
1632345486	1	2019-09-27 14:12:45.290131	2019-09-27 14:23:19.53051	assie	57715955	20	DALLAS	SALLA	48561803	5	DOKUI	2	CHAUSSURE	1	1000	4.578	3
1632345479	1	2019-09-27 14:11:16.01021	2019-09-27 14:23:20.717862	luv	12345678	94	koumassi	jean	22331545	66	plateau	1	livre	1	1250	13.242	3
1632345485	1	2019-09-27 14:12:43.815346	\N	LOU	45678909	66	POI	COU	67565434	45	YUI	1	EXTRAIT	1	1300	15.54	2
1632345495	1	2019-09-27 14:39:04.032585	\N	konan	11111111	37	DANGA	konan	11111111	25	SODECI	2	CHAUSSURE	1	1150	8.284	2
1632345484	65	2019-09-27 14:12:33.239619	2019-09-27 14:24:03.33732	konan	11111111	46	ANONO	konan	11111111	115	anyama	2	CHAUSSURE	1	1550	25.583	3
1632345491	1	2019-09-27 14:15:49.184246	\N	mi	23232323	3	rue 1	YOU	00000000	26	rue6	1	DIPLOME	1	1000	6.67	2
1632345487	1	2019-09-27 14:13:33.175842	2019-09-27 14:24:31.671831	assie	57715955	20	DALLAS	SALLA	48561803	94	DSD	2	CHAUSSURE	1	1350	16.541	3
1632345504	65	2019-09-27 14:40:57.493701	2019-09-27 14:54:25.468752	konan	87425935	46	anono	abobo	11111111	7	baoulé	2	CHAUSSURE	1	1250	12.04	3
1632345502	1	2019-09-27 14:40:54.608405	2019-09-27 14:46:06.948529	luc	66666666	94	koumassi	jean	11111111	64	cocody	2	lit	1	1400	18.165	3
1632345498	1	2019-09-27 14:40:21.548667	2019-09-27 14:45:34.820268	PI	99999999	6	RUE2	OH	99999999	100	rue6	2	CHEMISES	1	1300	14.521	3
1632345501	1	2019-09-27 14:40:46.918171	2019-09-27 14:46:30.340438	KOFFI	24252627	20	RU 	ASSIE	23232425	99	RUE 	2	MONTRE	1	1300	15.046	3
1632345508	1	2019-09-27 14:42:37.010861	2019-09-27 14:48:41.994716	PI	99999999	6	RUE2	wi	99999999	23	rue6	2	polo	1	1200	10.448	3
1632345503	1	2019-09-27 14:40:55.775053	\N	KOI	56767898	66	OIU	JOI	34343467	21	JKO	1	BAC	1	1000	3.38	2
1632345499	1	2019-09-27 14:40:22.931495	2019-09-27 14:52:44.694226	KOI	56767898	66	OIU	JOI	34343467	21	JKO	1	BAC	1	1000	3.38	3
1632345506	1	2019-09-27 14:42:07.07518	2019-09-27 14:46:40.966247	KOFFI	24252627	20	RU 	ASSIE	23232425	114	RUE 	2	MONTRE	1	1450	21.122	3
1632345500	1	2019-09-27 14:40:35.646717	2019-09-27 14:46:49.638843	luc	66666666	94	koumassi	jean	11111111	66	plateau	2	lit	1	1300	13.242	3
1632345507	1	2019-09-27 14:42:30.774336	\N	konan	11111111	37	DANGA	konan	11111111	25	SODECI	2	CHAUSSURE	1	1150	8.284	2
1632345497	1	2019-09-27 14:40:18.335009	2019-09-27 14:48:48.332498	luc	66666666	94	koumassi	jean	11111111	31	adjamé	2	lit	1	1450	20.654	3
1632345510	1	2019-09-27 14:43:31.523945	\N	luc	66666666	94	koumassi	jean	11111111	18	abobo	2	lit	1	1800	35.672	2
1632345523	1	2019-09-27 16:19:13.565268	2019-09-27 16:31:34.146452	luc	55541212	107	abidjan	jean	25258527	23	adjamé	2	lit	2	1650	28.433	3
1632345545	1	2019-10-07 14:27:43.674314	2019-10-07 14:57:54.103515	AS	11161616	1	MOSQUE	AYA	23232456	6	BVD	2	CHAUSSURE	1	1200	9.048	3
1632345511	1	2019-09-27 14:44:31.318088	2019-09-27 14:46:54.678792	PI	99999999	6	RUE2	VI	99999999	66	rue6	2	polo	1	1250	11.538	3
1632345512	1	2019-09-27 14:46:16.667119	2019-09-27 14:47:30.296945	PI	99999999	6	RUE2	SI	99999999	64	rue6	2	polo	1	1200	8.772	3
1632345524	1	2019-09-27 16:20:10.496094	2019-09-27 16:31:40.971814	koffi	34353637	20	voila sa	VIRUS MODI	23242526	104	MOUGOU PEN	2	LALA	1	1450	20.771	3
1632345514	1	2019-09-27 14:47:47.539003	\N	konan	11111111	37	DANGA	konan	11111111	25	PLATEAU	2	CHAUSSURE	1	1150	8.284	2
1632345538	58	2019-10-05 11:46:38.046991	2019-10-05 13:49:28.558642	Vladimir Poutine	03335684	61	Angré, Djibi	Zaguirov Roustame	04213587	91	Treichville, Biafra, rue 12	2	Paquets de stylos et crayons	1	1250	12.756	3
1632345525	1	2019-09-27 16:41:54.451275	\N	konan	08170894	37	Danga	konaté	12345678	105	ABATTOIR	2	balle blanche	1	1300	13.691	2
1632345515	1	2019-09-27 14:48:55.312732	\N	konan	11111111	37	DANGA	konan	11111111	66	PLATEAU	2	CHAUSSURE	1	1000	4.845	2
1632345496	1	2019-09-27 14:39:56.434252	2019-09-27 14:56:27.336818	luc	66666666	94	koumassi	jean	11111111	9	abobo	2	lit	1	1650	29.13	3
1632345513	1	2019-09-27 14:47:40.874273	2019-09-27 14:56:38.746268	KOI	56767898	66	OIU	JOI	34343467	91	JKO	1	BAC	1	1000	3.622	3
1632345516	1	2019-09-27 15:06:03.121336	\N	luc	22222222	94	koumassi	jean	22535525	45	cocody	2	lit	2	1450	21.731	2
1632345517	1	2019-09-27 15:25:56.908106	\N	konan	87425935	95	REMBLAIS	KONE	08524033	41	riviéra 1	2	CHAUSSURE	1	1000	6.219	2
1632345529	1	2019-09-30 10:54:01.266552	2019-09-30 12:12:30.581162	konan	89552735	1	gare	konaté	22222222	94	Sicogi	2	chaussure	1	1500	23.593	3
1632345518	1	2019-09-27 15:34:46.059501	\N	Amie	01010101	64	cocody	Mariam	40404040	102	marcory	1	diplome	1	1300	15.06	2
1632345526	1	2019-09-27 16:46:31.678683	2019-09-27 17:03:14.137201	konan	08170894	113	Aéroport	konaté	12345678	105	ABATTOIR	2	balle blanche	1	1150	7.285	3
1632345519	1	2019-09-27 16:10:18.267816	\N	hi	00000000	1	rue12	ha	55555555	104	rue7	1	DOSSIERS	1	1550	27.823	2
1632345531	1	2019-09-30 12:08:21.650402	2019-09-30 12:15:15.204142	konan	87425935	1	Gare	sidiki	01224456	94	sicogi	2	chaussure	1	1500	23.593	3
1632345532	1	2019-09-30 12:08:59.544122	2019-09-30 12:15:37.75635	konan	87425935	1	Gare	sidiki	01224456	102	biétry	2	chaussure	1	1500	23.356	3
1632345527	1	2019-09-27 17:11:36.237957	2019-09-27 17:24:29.075344	konan	08170894	37	danga	konaté	12345678	40	mermoz	2	balle blanche	1	1000	2.736	3
1632345521	1	2019-09-27 16:12:49.070779	2019-09-27 16:14:47.088719	hi	00000000	1	rue12	ha	55555555	104	rue7	1	DOSSIERS	1	1550	27.823	3
1632345520	1	2019-09-27 16:12:00.426285	2019-09-27 16:15:10.084248	luc	45316521	104	abidjan	jean	78154456	7	abobo	2	lit	2	1550	25.311	3
1632345522	1	2019-09-27 16:16:34.029653	\N	luc	52555555	96	abidjan	brice	77855555	26	adjamé	2	lit	2	1300	14.821	2
1632345539	58	2019-10-05 11:49:23.532561	2019-10-05 13:53:01.948601	Magamedov Gandhi	01458795	95	Remblais, pharmacie remblais	Sanaev Amir	59874531	99	Anoumaba, fabrique d'attiéké	1	Extraits de naissance	1	1000	1.387	3
1632345533	1	2019-10-01 14:32:01.496828	2019-10-01 14:38:45.105234	luc	02451274	95	78451236	paul	45967812	87	rue12	2	télépone portable	2	1000	6.044	3
1632345528	1	2019-09-30 10:23:27.841457	2019-09-30 10:46:32.924891	konan	11111111	1	gare	aissata	57612462	2	anador	2	chaussure	1	1000	2.626	3
1632345547	1	2019-10-07 14:29:48.093008	2019-10-07 15:01:34.431033	la vie	87610151	2	anadors	michou	57614246	72	liberté	2	iphone 6	2	1300	14.745	3
1632345537	58	2019-10-05 08:55:48.716572	2019-10-07 13:57:33.29506	Choumie	45671234	3	jffvyjjhwfg	Manass	79004562	40	vtujgertgf	1	sac à main	1	1250	14.479	3
1632345534	1	2019-10-01 14:41:31.889948	2019-10-01 14:49:31.003365	siaka 	48414540	20	carrefou ozangar	ouattara aissata	57612462	87	rue 12	2	bague de demande en mariage	1	1200	9.398	3
1632345540	58	2019-10-06 14:23:22.504683	2019-10-07 14:08:23.853358	Lil Dee	09876543	102	Biétry, zone 4C	Liam Payne	78543213	20	Williamsville, carrefour Mosquée	1	Chaussures	2	1300	16.088	3
1632345535	1	2019-10-01 15:42:14.559557	2019-10-01 15:45:06.108394	kouame	22321234	66	plateau	Jean Marc	22213467	66	plateau	2	ordinateur	2	1000	0	3
1632345549	1	2019-10-07 14:31:24.216107	2019-10-07 15:03:36.797319	AS	11161616	65	CHANDELIER	AYA	23232456	112	BVD	2	VOITURE	1	1800	34.878	3
1632345530	1	2019-09-30 12:01:34.372319	2019-09-30 12:06:44.865611	Paul	32112422	94	KOUMASSI	jean Marc	09876544	9	abobo	2	sac de riz	2	1650	29.13	3
1632345536	1	2019-10-02 09:34:04.688322	\N	ASSIE	57715955	114	KD	KOUAME	78454377	78	YOU	1	MONTRE	1	1450	23.039	4
1632345548	1	2019-10-07 14:29:57.55135	2019-10-07 15:06:33.549867	AS	11161616	68	MOSQUE	AYA	23232456	115	BVD	2	VOITURE	1	1500	22.436	3
1632345542	1	2019-10-07 14:23:53.227222	2019-10-07 15:07:35.675895	danielle	87610151	42	la 2	aissata	57614246	101	zone 4	2	placali sauce graine	2	1150	8.493	3
1632345546	1	2019-10-07 14:28:09.693096	2019-10-07 15:12:44.587291	mariam	87610151	66	lonchamps	christian	57614246	72	ananeraie	1	facture de chaussure	1	1250	13.213	3
1632345544	1	2019-10-07 14:26:55.029038	\N	AS	11161616	114	MOSQUE	AYA	23232456	72	BVD	2	CHAUSSURE	1	1650	28.372	2
1632345550	1	2019-10-07 14:33:19.600296	2019-10-07 15:12:57.551587	mde oué	87610151	26	pallet	aissata	57614246	77	batim	1	covocation	1	1200	12.215	3
1632345543	1	2019-10-07 14:26:33.478553	2019-10-07 15:12:33.362371	tenin	87610151	92	cite du personnel	la joie	57614246	72	ananeraie	1	extrait du gospion	1	1350	17.989	3
1632345551	1	2019-10-08 10:10:53.019227	2019-10-08 10:25:52.57773	aka	57715955	39	BON	KKB	34728964	51	CF KKB	1	DEPOS POLITIQUE 	1	1200	10.03	3
1632345554	1	2019-10-08 10:27:49.679618	2019-10-08 11:01:39.389814	aka	57715955	94	BON	KKB	34728964	51	CF KKB	1	DEPOS POLITIQUE 	1	1350	19.85	3
1632345553	1	2019-10-08 10:27:30.915527	2019-10-08 10:58:53.272897	Brice	45636622	94	koumassi	Jean	03256987	75	yopougon	2	ordinateur portable	2	1600	26.718	3
1632345541	1	2019-10-07 14:23:46.22429	2019-10-07 14:50:09.136409	AS	11161616	20	MOSQUE	AYA	23232456	41	BVD	2	MANGUES	1	1250	11.315	3
1632345552	1	2019-10-08 10:27:10.101618	2019-10-08 11:00:19.792083	Brice	45636622	94	koumassi	Jean	03256987	1	abobo	2	ordinateur portable	2	1600	26.817	3
1632345558	1	2019-10-08 10:29:05.799188	2019-10-08 10:41:26.793548	kouakou	11111111	4	RUE12	MARIAM	22222222	6	RUE	1	EXTRAITS	1	1250	14.679	3
1632345556	1	2019-10-08 10:28:13.793522	2019-10-08 11:02:06.679016	Brice	45636622	94	koumassi	Jean	03256987	107	abidjan	2	ordinateur portable	2	1400	18.1	3
1632345555	1	2019-10-08 10:27:51.533822	2019-10-08 11:01:47.978059	Brice	45636622	94	koumassi	Jean	03256987	65	cocody	2	ordinateur portable	2	1400	19.369	3
1632345557	1	2019-10-08 10:28:37.034056	2019-10-08 11:01:45.025609	Brice	45636622	94	koumassi	Jean	03256987	114	bingerville	2	ordinateur portable	2	1600	27.574	3
1632345570	1	2019-10-08 10:34:59.665131	2019-10-08 10:46:20.21247	president 	45636622	66	maison blanche	ouattara	03256987	87	portbouet 2	2	range rover	1	1000	3.675	3
1632345573	1	2019-10-08 10:38:20.422644	2019-10-08 10:48:22.390384	hkb	34728964	64	BZBE	ADO	20345678	101	CF KKB	2	ordinateur HP	1	1300	13.219	3
1632345574	1	2019-10-08 10:39:05.425233	2019-10-08 10:49:16.246608	AMIDOU	34728964	64	BZBE	ADO	20345678	101	CF KKB	2	ordinateur HP	1	1300	13.219	3
1632345562	1	2019-10-08 10:30:38.189036	2019-10-08 10:50:49.593854	hkb	57715955	66	BON	KKB	34728964	51	CF KKB	1	dossier	1	1250	13.659	3
1632345575	1	2019-10-08 10:52:59.368154	\N	gbapieu	12131415	7	XXX	YA PAS LHOMME	13141516	66	amoinkro	2	chat braiser	1	1400	19.134	2
1632345569	1	2019-10-08 10:34:40.46362	2019-10-08 10:55:00.119581	hkb	57715955	64	BON	KKB	34728964	75	CF KKB	2	ordinateur HP	1	1400	18.09	3
1632345572	1	2019-10-08 10:37:28.571114	2019-10-08 10:57:26.496634	ministre adjoumani	45636622	66	ministere	ouattara	03256987	72	portbouet 2	2	1 tonne de riz	1	1300	13.213	3
1632345563	1	2019-10-08 10:30:47.393236	2019-10-08 10:58:47.137938	Brice	45636622	94	koumassi	Jean	03256987	68	yopougon	2	ordinateur portable	2	1550	25.174	3
1632345568	1	2019-10-08 10:33:59.459656	\N	GBE	55555555	67	RUE 5	GBI	55555555	64	RUE	2	BAE	2	1400	17.908	2
1632345564	1	2019-10-08 10:31:27.249971	2019-10-08 10:59:46.202189	Brice	45636622	94	koumassi	Jean	03256987	85	yopougon	2	sac de riz	2	1550	24.364	3
1632345559	1	2019-10-08 10:29:17.370513	2019-10-08 11:00:46.809798	Brice	45636622	94	koumassi	Jean	03256987	115	anyama	2	ordinateur portable	2	1800	35.644	3
1632345561	1	2019-10-08 10:30:17.377562	2019-10-08 11:01:41.877224	Brice	45636622	94	koumassi	Jean	03256987	64	cocody	2	ordinateur portable	2	1400	18.165	3
1632345571	1	2019-10-08 10:35:25.097803	\N	GBU	66666666	67	RUE 5	GBOU	66666666	105	RUE	2	SAC	2	1550	25.178	2
1632345567	1	2019-10-08 10:32:45.723305	2019-10-08 11:01:50.553078	GBO	44444444	95	RUE 5	GBA	44444444	64	RUE	2	BAE	2	1250	12.363	3
1632345580	1	2019-10-08 11:09:54.561727	2019-10-08 11:40:55.228333	Jean	55215511	74	yopougon	Ouattara	78451236	42	abidjan	2	montre	2	1400	17.932	3
1632345596	1	2019-10-08 11:14:24.598115	2019-10-08 11:33:13.603446	tchrouuuuuu	00000000	114	Rrue5	OUFFFFFFFFF	00000000	109	rue3	1	DOSSIERS	1	1800	42.412	3
1632345560	1	2019-10-08 10:29:45.554661	2019-10-08 11:03:25.049128	Brice	45636622	94	koumassi	Jean	03256987	30	adjamé	2	ordinateur portable	2	1400	18.596	3
1632345578	1	2019-10-08 11:09:38.098433	2019-10-08 11:40:42.720421	Jean	55215511	74	yopougon	Ouattara	78451236	39	abidjan	2	montre	2	1450	19.597	3
1632345590	1	2019-10-08 11:12:52.003383	2019-10-08 11:17:45.849297	Jean	55215511	74	yopougon	Ouattara	78451236	80	abidjan	2	montre	2	1150	7.48	3
1632345592	1	2019-10-08 11:12:59.609439	2019-10-08 11:33:28.918139	tchrouuuuuu	00000000	114	Rrue5	OUFFFFFFFFF	00000000	110	rue3	1	DOSSIERS	1	1850	44.266	3
1632345565	1	2019-10-08 10:31:28.975601	2019-10-08 10:42:21.679748	ADO	33333333	41	RUE 5	HKB	33333333	64	RUE	2	FFCI	2	1150	8.586	3
1632345566	1	2019-10-08 10:32:25.902021	2019-10-08 10:43:35.896183	Brice	45636622	94	koumassi	Jean	03256987	87	treichville	2	sac de riz	2	1200	10.394	3
1632345605	1	2019-10-08 11:18:23.892217	2019-10-08 11:27:10.601158	AMADOU	57715955	20	MOSQUE	ADO	23459870	24	ERTY	2	ORDI	1	1000	4.723	3
1632345582	1	2019-10-08 11:10:39.467601	2019-10-08 11:31:19.7099	AMIDOU	32323245	20	MOSQUE	ADO	23459870	76	ERTY	2	CHAPEAU	1	1300	13.109	3
1632345587	1	2019-10-08 11:12:11.958645	2019-10-08 11:33:23.736307	tchrouuuuuu	00000000	114	Rrue5	OUFFFFFFFFF	00000000	107	rue3	1	DOSSIERS	1	1700	35.616	3
1632345599	1	2019-10-08 11:16:20.857931	2019-10-08 11:36:21.585008	PIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII	99999999	114	Rrue5	AHIIIIIIIIIIIIIII	88888888	39	rue3	1	VETEMENTS	1	1350	17.801	3
1632345600	1	2019-10-08 11:16:27.065003	2019-10-08 11:27:06.931676	AMADOU	57715955	20	MOSQUE	ADO	23459870	24	ERTY	2	MANGUE	1	1000	4.723	3
1632345601	1	2019-10-08 11:17:02.267717	2019-10-08 11:26:55.879272	AMADOU	57715955	20	MOSQUE	ADO	23459870	24	ERTY	2	MONTRE	1	1000	4.723	3
1632345584	1	2019-10-08 11:11:22.398091	2019-10-08 11:32:26.477388	tchrouuuuuu	00000000	114	Rrue5	OUFFFFFFFFF	00000000	104	rue3	1	DOSSIERS	1	1550	28.671	3
1632345594	1	2019-10-08 11:13:34.587629	2019-10-08 11:33:38.562323	tchrouuuuuu	00000000	114	Rrue5	OUFFFFFFFFF	00000000	113	rue3	1	DOSSIERS	1	1650	33.139	3
1632345598	1	2019-10-08 11:16:01.919311	2019-10-08 11:26:59.750255	AMADOU	57715955	20	MOSQUE	ADO	23459870	24	ERTY	2	DU FOUTOU	1	1000	4.723	3
1632345597	1	2019-10-08 11:15:33.988949	\N	PIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII	00000000	114	Rrue5	AHIIIIIIIIIIIIIII	00000000	39	rue3	1	VETEMENTS	1	1350	17.801	4
1632345576	1	2019-10-08 11:08:42.906462	2019-10-08 11:42:35.557661	Jean	55215511	74	yopougon	Ouattara	78451236	114	abidjan	2	montre	2	1700	31.182	3
1632345595	1	2019-10-08 11:14:06.437187	2019-10-08 11:31:03.738527	AMADOU	57715955	20	MOSQUE	ADO	23459870	78	ERTY	2	DU FOUTOU	1	1300	15.139	3
1632345591	1	2019-10-08 11:12:54.731299	2019-10-08 11:31:23.114242	AMADOU	32323245	20	MOSQUE	ADO	23459870	78	ERTY	2	CHAUSSURE	1	1300	15.139	3
1632345581	1	2019-10-08 11:10:10.450324	2019-10-08 11:41:35.373547	Jean	55215511	74	yopougon	Ouattara	78451236	46	abidjan	2	montre	2	1450	19.585	3
1632345602	1	2019-10-08 11:17:21.667166	2019-10-08 11:36:14.949975	PIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII	99999999	38	Rrue5	AHIIIIIIIIIIIIIII	88888888	40	rue3	1	VETEMENTS	1	1000	2.302	3
1632345583	1	2019-10-08 11:11:20.44243	2019-10-08 11:30:59.54856	ALI	32323245	20	MOSQUE	ADO	23459870	76	ERTY	2	CHAUSSURE	1	1300	13.109	3
1632345577	1	2019-10-08 11:09:24.763874	2019-10-08 11:40:29.119057	Jean	55215511	74	yopougon	Ouattara	78451236	37	abidjan	2	montre	2	1400	17.429	3
1632345579	1	2019-10-08 11:09:47.070161	2019-10-08 11:30:55.764328	as	32323245	20	MOSQUE	ADO	23459870	74	ERTY	2	CHAPEAU	1	1300	14.74	3
1632345588	1	2019-10-08 11:12:16.849596	2019-10-08 11:17:54.895209	Jean	55215511	74	yopougon	Ouattara	78451236	84	abidjan	2	montre	2	1200	10.661	3
1632345593	1	2019-10-08 11:13:04.177117	2019-10-08 11:17:39.466039	Jean	55215511	74	yopougon	Ouattara	78451236	78	abidjan	2	montre	2	1550	25.199	3
1632345589	1	2019-10-08 11:12:38.726602	2019-10-08 11:17:43.423499	Jean	55215511	74	yopougon	Ouattara	78451236	81	abidjan	2	montre	2	1000	4.603	3
1632345586	1	2019-10-08 11:12:02.344386	2019-10-08 11:17:49.10813	Jean	55215511	74	yopougon	Ouattara	78451236	86	abidjan	2	montre	2	1000	2.008	3
1632345585	1	2019-10-08 11:11:37.325259	2019-10-08 11:42:06.77093	Jean	55215511	74	yopougon	Ouattara	78451236	50	abidjan	2	montre	2	1500	22.01	3
1632345604	1	2019-10-08 11:18:16.36974	2019-10-08 11:35:55.319429	PIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII	99999999	39	Rrue5	AHIIIIIIIIIIIIIII	88888888	37	rue3	1	VETEMENTS	1	1000	3.037	3
1632345603	1	2019-10-08 11:17:50.538269	2019-10-08 11:26:52.207035	AMADOU	57715955	20	MOSQUE	ADO	23459870	24	ERTY	2	TELEPHONE 	1	1000	4.723	3
1632345607	1	2019-10-08 15:10:03.31322	2019-10-08 15:17:41.776449	charmel	87610151	42	la 2	ahmed	11111111	114	bingerville	2	ordinateur	2	1350	16.044	3
1632345608	1	2019-10-08 15:39:24.873007	2019-10-08 15:46:46.692112	han	55545555	3	samaké	hiiii	22222222	1	gare	1	extrait	1	1000	2.844	3
1632345606	58	2019-10-08 15:03:12.434323	2019-10-08 15:52:19.340926	kk	05050505	31	rue 6	hhh	04040404	67	mode	2	chaussures 	2	1200	9.081	3
1632345609	72	2019-10-08 15:55:33.176555	2019-10-08 16:04:21.670092	Hadi	49859528	20	champs Élysée 	soualio	78830760	43	Faya 	1	chaussure 	1	1200	10.905	3
1632345610	1	2019-10-09 13:58:47.177185	2019-10-09 14:04:30.232722	mariette	65656565	1	gare	aicha	25623532	72	annanéraie	1	livre 	2	1300	16.152	3
1632345642	1	2019-10-18 11:26:01.146733	2019-10-18 11:28:22.032268	pla	11111111	66	RUE4	COUCOU	22222222	64	RUE2	2	CHAINES	1	1300	13.16	3
1632345611	65	2019-10-09 14:51:03.038213	2019-10-09 15:16:43.631215	ADÈLE 	48561803	21	SODECI	danielle	57715955	24	SOSSO	2	sac a main	1	1000	6.625	3
1632345612	65	2019-10-10 10:05:06.988016	2019-10-10 10:17:11.303661	ass	48561803	72	annaneraie	kane	87786766	115	anyama	2	CHAUSSURE	1	1450	20.305	3
1632345621	1	2019-10-16 14:49:58.697056	2019-10-16 15:18:08.036804	MR mal	07700770	12	agb	Mr faux	09090909	18	N'doho	2	drouvi	1	1150	8.413	3
1632345614	64	2019-10-10 12:03:36.556538	2019-10-10 12:25:38.72054	peley	42790375	42	station oil lybia	Marie Esther	57321382	8	grand marché	2	vêtements	2	1400	18.276	3
1632345615	64	2019-10-10 12:33:08.424454	2019-10-10 12:45:39.22573	peley	07507384	98	rue 23	séphora	01010101	72	rue20	1	extrait	1	1450	23.775	3
1632345653	1	2019-10-18 11:52:17.646404	2019-10-18 12:02:15.807766	GOU	00000000	66	RUE6	CHOUCOU	99999999	37	RUE3	1	HABITS	1	1000	5.349	3
1632345640	1	2019-10-18 11:24:18.074184	2019-10-18 11:41:50.176115	YOYO	22350200	3	ABOBO	JOLIE	23308040	105	PORT BOUET	1	EXTRAIT	2	1500	26.602	3
1632345616	1	2019-10-10 12:55:13.096205	2019-10-10 13:00:30.525052	peley	07507384	1	samake	gor	46010111	9	mosque	2	facture	1	1000	3.792	3
1632345623	1	2019-10-17 09:02:09.024621	\N	A	44444444	19	rue4	B	55555555	39	rue3	2	foulards	1	1000	5.521	4
1632345649	1	2019-10-18 11:51:41.497676	2019-10-18 11:54:27.641631	yao	09100683	105	abattoir	koffi	22222222	107	gonzagueville	2	chaussure	2	1250	11.76	3
1632345624	1	2019-10-17 09:03:32.116452	2019-10-17 09:43:47.737536	A	44444444	114	rue4	B	55555555	39	rue3	2	foulards	1	1400	17.801	3
1632345641	1	2019-10-18 11:25:10.462846	2019-10-18 11:28:30.380091	pla	11111111	66	RUE4	CICI	22222222	42	RUE2	2	CHAINES	1	1150	8.238	3
1632345617	1	2019-10-10 13:04:56.916109	2019-10-15 09:49:23.610746	peley	07777777	31	gendamerie	ashlet	05050505	10	eglise van	2	habit	1	1300	15.004	3
1632345613	71	2019-10-10 10:46:06.314171	2019-10-15 09:49:32.761062	benzou	78830760	20	Williamsville rue des Champs Elysées 	diablo	79793937	10	abobo anonkoua	2	enveloppe 	1	1350	16.989	3
1632345625	1	2019-10-17 16:52:40.876176	\N	ahjgb	04258791	14	ciyedcvhjklmnbhjg	jdv;njbhu	07525206	34	xdcfghn mvncgrsrtedyguibhk	1	extraits	1	1300	16.023	4
1632345618	70	2019-10-10 23:15:15.623422	2019-10-15 09:54:49.576659	Zerbo 	89865492	115	Barbara 	Touré 	88786812	105	Borabora 	2	Lit 	1	1800	35.046	3
1632345636	1	2019-10-18 11:21:56.284926	2019-10-18 11:41:55.437855	choupi	22302200	1	ABOBO	DODO	23304040	105	PORT BOUET	1	EXTRAIT	1	1500	26.021	3
1632345619	72	2019-10-15 11:29:13.21223	2019-10-15 12:33:08.926019	Abdoul hadi 	49859528	61	angre 	soualio 	78830760	102	bietry	1	sac	1	1300	15.69	3
1632345635	1	2019-10-18 11:21:19.217284	2019-10-18 11:44:16.236508	kouassi	09100683	105	abattoir	adama	09100686	115	anyama	1	extrait de naissance	2	1650	34.454	3
1632345620	1	2019-10-15 15:16:33.864972	2019-10-15 15:27:14.227245	dodo(è	57715955	72	ane	nana	48561803	69	BIM	2	sacs a  main	1	1250	10.879	3
1632345643	1	2019-10-18 11:26:34.842528	2019-10-18 11:42:04.300397	BEN	22350222	5	ABOBO	JULIE	23408040	106	PORT BOUET	2	SAC	1	1450	21.443	3
1632345627	1	2019-10-18 11:15:53.27319	2019-10-18 11:30:45.984427	Othniel	57612462	40	mermoz	ouattara	55555555	66	sorbonne	2	frite poulet	1	1000	6.956	3
1632345644	1	2019-10-18 11:28:18.50774	2019-10-18 11:42:08.168174	BENI	22362222	6	ABOBO	JOHN	23408040	107	PORT BOUET	2	CHAUSSURES	2	1600	27.995	3
1632345645	1	2019-10-18 11:29:27.66566	2019-10-18 11:42:12.604633	CHERI	22362220	7	ABOBO	WENN	23408041	109	PORT BOUET	2	CHAUSSURES	1	1900	39.231	3
1632345633	1	2019-10-18 11:19:40.968512	2019-10-18 11:43:59.681573	kouassi	09100683	105	abattoir	adamo	09100685	2	anador	2	montre	1	1500	23.455	3
1632345656	1	2019-10-18 11:53:42.369785	2019-10-18 12:03:49.309516	JULES	12121214	2	ABOBO	PAPA	30303032	113	PORT BOUET	1	BULLETIN	1	1600	31.296	3
1632345626	1	2019-10-18 11:15:02.412879	2019-10-18 11:30:50.918779	kouakou	57612462	40	mermoz	aissata	55555555	66	sorbonne	2	soupe de chat	1	1000	6.956	3
1632345631	1	2019-10-18 11:18:03.124718	2019-10-18 11:30:57.406636	melanie	57612462	40	la 2	brice	55555555	66	sorbonne	2	portable	2	1000	6.956	3
1632345632	1	2019-10-18 11:19:01.768018	2019-10-18 11:31:08.083854	landry	57612462	40	la 2	Miss Ouattara	55555555	66	sorbonne	2	voiture rouge	2	1000	6.956	3
1632345639	1	2019-10-18 11:23:54.853649	2019-10-18 11:44:03.503928	kouassi	09100683	105	abattoir	koffi	09100688	4	akeikoi	1	certificat de nationnalité	2	1600	31.345	3
1632345659	1	2019-10-18 11:55:16.293558	2019-10-18 12:02:29.692917	GOU	00000000	66	RUE6	CHROUCHROU	99999999	46	RUE3	1	LITS	1	1150	9.728	3
1632345628	1	2019-10-18 11:16:56.341642	2019-10-18 11:31:14.324371	mariam	57612462	40	la 2	aichou	55555555	66	sorbonne	2	foutou sauce graine	2	1000	6.956	3
1632345634	1	2019-10-18 11:21:05.870916	2019-10-18 11:28:03.630502	pla	11111111	66	RUE4	DYDY	22222222	38	RUE2	2	CHAINES	1	1000	5.691	3
1632345638	1	2019-10-18 11:23:13.170807	2019-10-18 11:28:14.491635	pla	11111111	66	RUE4	DODO	22222222	39	RUE2	2	CHAINES	1	1150	7.517	3
1632345630	1	2019-10-18 11:17:52.280896	2019-10-18 11:28:18.464251	pla	11111111	66	RUE4	COCO	22222222	40	RUE2	2	BIJOUX	2	1000	6.569	3
1632345629	1	2019-10-18 11:16:59.437892	2019-10-18 11:44:08.163262	kouassi	09100683	105	abattoir	sangare	09100684	1	gare	2	chaussure	2	1550	25.627	3
1632345637	1	2019-10-18 11:22:25.742295	2019-10-18 11:44:11.812096	kouassi	09100683	105	abattoir	sylla	09100687	5	dokui	1	casier judiciaire	1	1400	20.655	3
1632345655	1	2019-10-18 11:53:08.636686	2019-10-18 12:02:22.399705	GOU	00000000	66	RUE6	CHACHA	99999999	38	RUE3	1	BOUCLES	1	1000	5.691	3
1632345651	1	2019-10-18 11:51:56.976543	2019-10-18 11:54:21.952369	yao	09100683	105	abattoir	koffi	22222222	107	gonzagueville	2	chaussure	2	1250	11.76	3
1632345657	1	2019-10-18 11:54:06.510745	2019-10-18 12:02:19.62486	GOU	00000000	66	RUE6	CHECHE	99999999	42	RUE3	1	POUBELLES	1	1150	8.238	3
1632345654	1	2019-10-18 11:52:36.993518	\N	PRINCE	12121213	2	ABOBO	CHARLES	30303030	110	PORT BOUET	1	EXTRAIT	1	1800	42.218	4
1632345650	1	2019-10-18 11:51:49.693382	2019-10-18 11:54:24.918033	yao	09100683	105	abattoir	koffi	22222222	107	gonzagueville	2	chaussure	2	1250	11.76	3
1632345646	1	2019-10-18 11:40:38.043243	2019-10-18 11:59:30.134831	kouassi	07507384	1	rue2	yavo	46620546	53	rue 21	1	diplome	2	1250	13.974	3
1632345647	1	2019-10-18 11:50:40.483867	2019-10-18 11:54:30.642103	yao	09100683	105	abattoir	koffi	22222222	107	gonzagueville	1	extrait de naissance	2	1200	11.76	3
1632345652	1	2019-10-18 11:52:16.072756	2019-10-18 11:54:18.265481	yao	09100683	105	abattoir	koffi	22222222	107	gonzagueville	2	clef	2	1250	11.76	3
1632345660	1	2019-10-18 11:55:23.526892	2019-10-18 12:04:58.284621	yao	09100683	105	abattoir	koffi	22222222	18	n'dotré	2	clef	2	1750	34.482	3
1632345648	1	2019-10-18 11:51:22.64416	2019-10-18 12:03:38.824899	VONI	12121212	1	ABOBO	CHOUMI	30303030	107	PORT BOUET	1	CASIER JUDICIAIRE	1	1650	34.754	3
1632345622	1	2019-10-16 14:56:03.539526	2019-10-24 08:40:51.539776	Niangoran Boua	04589713	42	Riviéra 2, rue Alpha	Mister You	56719832	26	Paillet, rue 13	2	Chaussures	1	1200	9.07	3
1632345682	70	2019-10-22 13:20:04.140947	2019-10-24 08:40:46.176022	AKWABA EXPRESS SARL	20370174	20	williamsville, croix bleue	Linda KOUASSI	08148762	19	Saint-Michel, marché Gouro	1	doucument	1	1000	5.395	3
1632345683	62	2019-11-03 12:39:14.084446	\N	Daniel 	87612462	72	annaneraie	zenab	57610151	2	anador	1	portable  iphone 8	1	1250	14.021	4
1632345670	1	2019-10-18 12:02:05.437507	2019-10-18 12:09:06.886295	GOU	00000000	66	RUE6	CHICHA	99999999	66	RUE3	1	AWADJI	1	1000	0	3
1632345674	1	2019-10-18 12:05:27.985505	2019-10-18 12:09:11.071598	GOU	00000000	66	RUE6	CHICHA	99999999	66	RUE3	1	BUREAU	1	1000	0	3
1632345671	1	2019-10-18 12:02:51.165058	2019-10-18 12:09:19.52568	GOU	00000000	66	RUE6	CHICHA	99999999	66	RUE3	1	ORDINATEURS	1	1000	0	3
1632345694	1	2019-11-05 14:12:20.086875	2019-11-06 15:59:55.565451	amed	84165231	68	siporex	chantou	72159613	104	vridi	2	portable	2	1450	20.291	3
1632345667	1	2019-10-18 11:57:35.748806	\N	GOU	00000000	66	RUE6	CHICHA	99999999	46	RUE3	1	FAUTEUIL	1	1150	9.728	4
1632345685	1	2019-11-05 09:27:49.38445	2019-11-06 11:02:36.789196	aissa	57612462	1	gare	tresor	22222222	8	sogefia	1	bulletin	1	1000	3.683	3
1632345669	1	2019-10-18 12:01:16.689866	2019-10-18 12:11:24.644307	GOU	00000000	66	RUE6	CHICHA	99999999	66	RUE3	1	FAUTEUIL	1	1000	0	3
1632345673	1	2019-10-18 12:04:37.355469	2019-10-18 12:11:29.129008	GOU	00000000	66	RUE6	CHICHA	99999999	66	RUE3	1	FOURNITURES	1	1000	0	3
1632345663	1	2019-10-18 11:56:08.605607	2019-10-18 12:02:26.344997	GOU	00000000	66	RUE6	CHICHA	99999999	46	RUE3	1	FAUTEUIL	1	1150	9.728	3
1632345668	1	2019-10-18 11:59:32.905071	2019-10-18 12:03:35.526105	PAP	12121217	5	ABOBO	MEME	30303034	104	PORT BOUET	1	RECEPICE	1	1450	22.839	3
1632345666	1	2019-10-18 11:56:51.334118	2019-10-18 12:03:41.579151	VIEUX	12121216	3	ABOBO	MAMAN	30303034	112	PORT BOUET	1	FACTURE	1	1850	43.176	3
1632345658	1	2019-10-18 11:55:05.655693	2019-10-18 12:03:45.519187	PEPE	12121215	4	ABOBO	MAMA	30303033	113	PORT BOUET	1	CHARTE	1	1750	38.667	3
1632345672	1	2019-10-18 12:03:47.50417	2019-10-18 12:11:43.38634	GOU	00000000	66	RUE6	CHICHA	99999999	66	RUE3	1	BANCS	1	1000	0	3
1632345662	1	2019-10-18 11:55:56.851187	2019-10-18 12:04:45.431307	yao	09100683	105	abattoir	koffi	22222222	18	n'dotré	2	chaussure	2	1750	34.482	3
1632345665	1	2019-10-18 11:56:29.839663	2019-10-18 12:04:48.924496	yao	09100683	105	abattoir	koffi	22222222	18	n'dotré	1	extrait de naissance	2	1650	34.482	3
1632345661	1	2019-10-18 11:55:38.316159	2019-10-18 12:04:52.279109	yao	09100683	105	abattoir	koffi	22222222	18	n'dotré	2	chaussure	2	1750	34.482	3
1632345687	62	2019-11-05 10:05:25.765227	2019-11-05 10:14:14.260594	ouattara 	57612462	1	gare 	michel	87612452	6	zoo	2	chaussures 	1	1200	9.048	3
1632345664	1	2019-10-18 11:56:11.109205	2019-10-18 12:05:08.348011	yao	09100683	105	abattoir	koffi	22222222	18	n'dotré	2	montre	2	1750	34.482	3
1632345691	1	2019-11-05 12:30:58.299174	2019-11-06 12:30:18.846026	ouattara	54871263	2	anador	amira	52146398	114	bingerville	1	ramme	1	1500	26.767	3
1632345686	1	2019-11-05 09:28:50.839623	2019-11-06 11:06:21.759086	aissata	57612462	1	gare	tresor	22222222	7	abobo	2	montre	1	1000	6.759	3
1632345677	1	2019-10-18 12:09:43.258756	2019-10-18 12:15:54.111417	JOLI	19121214	1	ABOBO	YOYO	32303036	8	ABOBO	2	CHAUSSURE	2	1000	3.683	3
1632345678	1	2019-10-18 12:10:36.636068	2019-10-18 12:15:57.555261	ALI	18121214	2	ABOBO	PIPI	32303036	11	ABOBO	2	CHAISE	2	1200	10.241	3
1632345679	1	2019-10-18 12:11:40.147763	2019-10-18 12:16:01.009626	KONE	17121214	3	ABOBO	LADJI	33303036	18	ABOBO	2	TABLE	2	1200	8.732	3
1632345675	1	2019-10-18 12:07:15.009678	2019-10-18 12:16:05.090675	VAL	12121216	5	ABOBO	MEME	30303035	115	ABOBO	2	SAC	2	1300	14.289	3
1632345676	1	2019-10-18 12:08:35.985431	2019-10-18 12:16:10.054527	DJA	12121214	5	ABOBO	PAL	30303036	8	ABOBO	2	MONTRE	2	1150	7.667	3
1632345680	58	2019-10-18 13:39:59.972607	\N	Choumie	09763454	67	Selmer, institut Ifef 	Michou	76891234	102	Biétry, Centre	1	Sac	1	1450	22.643	2
1632345681	70	2019-10-22 11:17:13.713089	\N	AKWABA EXPRESS SARL	20370174	20	williamsville, croix bleue 	Linda KOUASSI	08148762	19	Saint-Michel, marché Gouro	1	doucument	1	1000	5.395	2
1632345696	1	2019-11-05 14:18:26.932238	2019-11-06 16:10:55.851461	pantcho	47172803	72	nouveau marche	tantie	72145562	95	remblais	2	carton de papier HP	1	1450	21.598	3
1632345690	62	2019-11-05 12:26:15.578533	2019-11-06 12:40:39.488594	aicha	89000734	66	Sorbonne 	dani	09876543	65	cocody	1	mèche 	1	1200	11.29	3
1632345693	1	2019-11-05 14:09:19.263416	2019-11-06 15:59:49.727136	mikal	84155231	17	bellville	chantal	78459613	104	gonzagueville	1	extrait	1	1500	25.227	3
1632345699	1	2019-11-05 14:22:21.588012	2019-11-06 15:55:32.656797	pintate rase	08887768	75	MOUSSO GBê	sougouya	09996754	41	attrape ton maris	2	valise	1	1400	17.427	3
1632345698	1	2019-11-05 14:21:12.511511	2019-11-06 16:11:00.677506	pathie	47172854	76	gesco	mariam	52478965	99	anoumabo	1	carton de patte	2	1450	22.926	3
1632345697	1	2019-11-05 14:19:26.609177	\N	mouton premier 	08729982	78	MOUSSO FIMAN	cabri deusieme	08729983	25	AMANANKATA	2	valise	1	1300	13.311	2
1632345702	1	2019-11-05 14:26:50.069889	2019-11-06 16:11:03.139884	ange	47175854	76	gesco	mirame	49618965	99	anoumabo	2	miel	1	1500	22.926	3
1632345700	65	2019-11-05 14:23:41.268453	2019-11-06 15:55:44.850099	ASSIE	57715955	20	Marseille	N'dri	48489708	114	gourokro	2	portable marque iphone	1	1450	21.122	3
1632345703	1	2019-11-05 14:27:50.392122	2019-11-06 16:00:01.369288	mamite	08887748	68	chez zongo	zogorda la legende	09996754	105	aweler katier	2	valise	1	1500	23.696	3
1632345704	65	2019-11-05 14:28:04.036981	2019-11-06 15:55:41.500701	Monique	48561803	20	rambo 	VIVI	59061324	114	LG 	2	micro onde	1	1450	21.122	3
1632345706	1	2019-11-05 14:30:39.058059	2019-11-06 12:36:09.967576	ango	47175854	75	banco nord	mirame	49618965	66	pyramide	2	voiture	1	1250	10.977	3
1632345705	1	2019-11-05 14:30:35.199778	2019-11-06 12:38:56.22517	carserole mamitte assiete	45556677	64	daishi	abordjoler	09996754	109	gnomi laper	2	valise	1	1750	33.217	3
1632345707	1	2019-11-05 14:32:46.497144	2019-11-06 12:49:27.610162	daniel	77175854	21	banco nord	mirame	49614514	64	palmeraie	1	PC	2	1200	11.508	3
1632345689	62	2019-11-05 12:18:26.951168	2019-11-06 12:50:02.503637	sali	56789022	20	willy 	sara	34215678	61	angre 	2	jean	2	1000	6.659	3
1632345709	1	2019-11-05 14:35:33.544057	2019-11-06 12:29:27.698383	Miss NIONGUI	01020304	7	rue 123	Miss MEMELLE	09080706	39	rue 12	2	PAGNES	2	1300	14.209	3
1632345684	1	2019-11-04 16:29:51.203719	2019-11-06 08:57:28.208243	tasaba	49339567	2	VOILA SA	MR GROS NEZ	48339567	24	MAIS OUIIII	1	bouloir	1	1000	4.777	3
1632345692	1	2019-11-05 14:06:27.85754	2019-11-06 12:52:17.43602	mael	87952314	22	dallas	rafi	74859613	107	gonzagueville	2	t-shirte	1	1500	22.401	3
1632345688	62	2019-11-05 12:16:50.307727	\N	fee	 7612462	68	siporex 	mia	66666669	99	anoumabo	2	tissage 	2	1450	19.759	2
1632345708	1	2019-11-05 14:35:07.108929	2019-11-06 12:24:05.233734	Amadou	56475432	1	dougoutiki	le gros	77889900	91	Chiiiiiiii	1	sac de soumara 	1	1300	16.383	3
1632345695	1	2019-11-05 14:14:16.927129	2019-11-06 16:10:53.308281	ami	52147803	72	annaneraie	charly	72185622	93	chu	1	ordornance	2	1300	15.058	3
1632345701	1	2019-11-05 14:25:16.434499	2019-11-06 16:00:04.013133	lion bancale	08887748	71	casé cous	mimi la go	09996754	105	c'est gatté naninan	2	valise	1	1700	32.566	3
1632345727	1	2019-11-05 15:18:12.510041	2019-11-06 12:24:47.224304	lekile	23334455	3	SAVA ALLER	adjigui	48339567	96	TAPR DEDANS	2	CHAT	2	1500	22.758	3
1632345717	1	2019-11-05 14:59:27.679449	2019-11-06 16:04:47.07801	MAIMOUNA	33333333	115	rue 126	CHICHIA	99999999	68	rue 14	2	CLIMATISSEURS	1	1500	22.537	3
1632345736	1	2019-11-05 15:42:11.791923	2019-11-06 16:04:56.621287	rachida	10256548	19	adjame	mari	14785945	74	koute	1	photo	1	1300	16.618	3
1632345716	1	2019-11-05 14:58:25.777805	2019-11-06 16:04:44.164024	Miss NIONGUI	14141414	115	rue 126	MIMI	00000000	68	rue 14	2	JOUETS ET POUPEES	1	1500	22.537	3
1632345712	1	2019-11-05 14:41:10.55835	\N	Miss NIONGUI	14141414	113	rue 126	M.AWA	99999999	30	rue 14	2	CHEMISES	1	1450	21.251	2
1632345732	1	2019-11-05 15:32:17.613041	2019-11-06 15:45:35.031027	Miss NIONGUI	66666666	88	rue 126	TITI	00000000	93	rue 14	2	VELOS 	2	1350	16.773	3
1632345720	1	2019-11-05 15:08:40.843539	\N	ladji	88888888	42	riviera 2	issouf	11111111	23	mosquee	2	sac de riz	2	1200	10.054	2
1632345723	1	2019-11-05 15:13:32.58457	2019-11-06 13:08:07.131646	ADO	00202123	40	MERM	BENOIR	34729708	61	CEP1	1	Lettre de demition 	1	1000	6.07	3
1632345722	1	2019-11-05 15:11:56.962926	2019-11-06 15:13:11.355043	adja sylla	77777777	84	zone	miriame	33333333	69	bimbresso	2	pagne	1	1300	13.814	3
1632345719	1	2019-11-05 15:07:19.110561	2019-11-06 16:04:54.21949	adou	49066609	44	dfg	douclou	34729708	70	ABC	2	DODO	1	1650	29.924	3
1632345721	1	2019-11-05 15:10:09.704331	\N	latifa	99999999	84	riviera 2	issouf	22222222	23	mosquee	1	devis	2	1150	8.455	2
1632345718	1	2019-11-05 15:00:25.74881	2019-11-06 15:33:13.918016	MAIMOUNA	33333333	107	rue 126	CHouchou	99999999	105	rue 14	2	fauteuils	1	1250	11.222	3
1632345743	1	2019-11-05 15:55:38.870624	2019-11-06 12:51:40.290977	MiFAGA	77777777	112	rue1	JOYA	44444444	94	rue5	2	GESTIONNAIRE	2	1450	20.859	3
1632345724	1	2019-11-05 15:13:51.876903	2019-11-06 12:22:34.899351	sylla	85482154	3	abobo	mie	55555555	10	anonkoua	1	rapport	1	1150	8.207	3
1632345750	1	2019-11-05 16:06:14.530161	2019-11-06 12:36:00.618084	BON 	77777777	46	rue1	QUAND	44444444	101	rue5	2	BASSINES	1	1150	8.218	3
1632345728	1	2019-11-05 15:21:35.081705	2019-11-06 12:32:02.543037	méléké	23334455	91	kokota	monter decendre	48339567	96	TAPR DEDANS	2	calendrier	2	1150	8.21	3
1632345726	1	2019-11-05 15:17:48.151248	2019-11-06 12:26:46.875518	aicha	55555555	56	attoban	ria	41414141	39	bingerville	2	telephone fixe	2	1000	5.92	3
1632345714	1	2019-11-05 14:44:14.405801	2019-11-06 16:04:49.594556	Miss NIONGUI	14141414	115	rue 126	MIMI	00000000	68	rue 14	2	DECO ET ACCESSOIRES	1	1500	22.537	3
1632345729	1	2019-11-05 15:23:08.985913	2019-11-06 15:46:04.39469	djorgouiiiiiiiii	67889900	88	POPLA	monter decendre	48339567	99	petit poto	2	calendrier	2	1300	13.581	3
1632345730	1	2019-11-05 15:29:01.651957	\N	Miss NIONGUI	66666666	110	rue 126	PIPO	99999999	114	rue 14	2	PHOTOCOPIEUSES	2	2000	43.701	2
1632345731	1	2019-11-05 15:30:27.473371	\N	Miss NIONGUI	66666666	110	rue 126	POPI	99999999	114	rue 14	2	TELEPHONE MACHINES A COUDRES	2	2000	43.701	2
1632345715	1	2019-11-05 14:57:17.945731	2019-11-06 15:59:52.760819	dindon 	45556677	62	mais ouiiiiiiii	maria mobile	09996754	109	gnomi laper	2	valise	1	1850	38.405	3
1632345739	1	2019-11-05 15:48:50.728998	2019-11-06 16:11:14.187478	kong ARRIVE	56889967	82	bouba	monter decendre	77889945	102	DEMARER TI MOTO	2	calendrier	2	1650	28.423	3
1632345734	1	2019-11-05 15:36:30.169808	2019-11-06 15:45:56.635964	Miss NIONGUI	00000000	102	rue1	BIBI	44444444	95	rue5	1	FOURNITURES DE BUREAUX	2	1000	4.776	3
1632345738	1	2019-11-05 15:47:56.789038	2019-11-06 16:11:05.376072	konan	00000025	114	bingerville	kouassi	584965__	101	zone 4c	1	pagne	2	1400	22.363	3
1632345735	1	2019-11-05 15:39:56.968181	2019-11-06 16:10:58.277892	rachida	02125478	66	plateau	maria	14785962	96	port bouet 2	1	album photo	2	1150	8.185	3
1632345737	1	2019-11-05 15:46:29.946947	2019-11-06 16:11:09.774448	kouadio	00000000	4	akeikoi	koussi	02514893	101	zone 4c	1	une bouteille de vin	2	1500	27.479	3
1632345733	1	2019-11-05 15:35:27.603252	2019-11-06 16:11:11.915326	kong	56889967	85	POPLA	monter decendre	77889945	102	DEMARER TI MOTO	2	calendrier	2	1450	19.977	3
1632345740	1	2019-11-05 15:50:35.501046	2019-11-06 16:11:16.170246	pabmo escoba	09828375	78	POUPI	LEBEdher	05422903	102	KOUDIO	2	calendrier	2	1000	3.648	3
1632345761	58	2019-11-05 17:22:06.906648	2019-11-06 12:10:38.496519	kk	09090909	29	rue la paix 	venix	56768700	94	rue jean	2	facture	2	1400	18.933	3
1632345746	1	2019-11-05 15:58:14.123326	2019-11-06 12:51:14.660098	MiFAGA	77777777	112	rue1	JOYA	44444444	94	rue5	1	MARKET	2	1400	20.859	3
1632345742	1	2019-11-05 15:55:38.759496	2019-11-06 12:40:30.141857	HYVI	09828375	32	macheter	pitigo	05422903	61	KOUDIO	2	méche	2	1450	21.045	3
1632345711	1	2019-11-05 14:39:29.180688	2019-11-06 12:26:09.646803	Miss NIONGUI	01020304	7	rue 126	M.GAEL	88888888	72	rue 14	2	CHEMISES	1	1450	19.833	3
1632345754	1	2019-11-05 16:21:03.9731	2019-11-06 12:51:59.75643	lolo	77777777	26	rue1	lala	44444444	110	rue5	1	montres	1	1700	36.572	3
1632345710	1	2019-11-05 14:39:01.375936	2019-11-06 12:49:53.204837	KASS	77175887	25	sodeci	oumar	1214584_	64	riviera	2	bic	1	1250	12.613	3
1632345758	1	2019-11-05 16:26:38.980229	2019-11-06 12:54:19.623377	CES MOI	77777777	19	rue1	CES TOI	44444444	90	rue5	1	chaises	1	1000	6.662	3
1632345745	1	2019-11-05 15:57:48.986785	2019-11-06 12:49:52.497743	MiFAGA	77777777	112	rue1	JOYA	44444444	94	rue5	1	SECRET	2	1400	20.859	3
1632345747	1	2019-11-05 15:59:46.386404	2019-11-06 12:48:50.30161	pipo	02345678	29	GALETTE	KOFFI	05422903	61	KOUDIO	2	BONBON	2	1150	7.36	3
1632345748	1	2019-11-05 16:01:26.287009	2019-11-06 12:36:10.779574	MiFAGA	77777777	46	rue1	YAKOI	44444444	94	rue5	2	BIOUX	2	1200	10.296	3
1632345751	1	2019-11-05 16:07:29.956088	2019-11-06 11:15:03.403755	COURSE	77777777	96	rue1	VITE	44444444	99	rue5	2	TEE-SHIRT	1	1000	2.383	3
1632345752	1	2019-11-05 16:10:43.867577	2019-11-06 11:11:46.663935	COURSE	77777777	115	rue1	VITE	44444444	115	rue5	1	FOURNITURES SCOLAIRES	1	1000	0	3
1632345741	1	2019-11-05 15:54:22.555472	2019-11-06 12:51:52.527445	MiFAGA	77777777	112	rue1	JOYA	44444444	93	rue5	1	PORTABLE	2	1550	28.736	3
1632345756	1	2019-11-05 16:24:11.652266	2019-11-06 12:54:33.883664	Arafat	77777777	20	rue1	arafat	44444444	90	rue5	1	albums	1	1200	10.266	3
1632345749	1	2019-11-05 16:05:36.398341	2019-11-06 12:36:05.78127	VIENT	77777777	46	rue1	VA	44444444	101	rue5	2	BASSINES	1	1150	8.218	3
1632345755	1	2019-11-05 16:22:23.711145	\N	lili	77777777	54	rue1	poooooo	44444444	83	rue5	1	meches	1	1350	17.545	2
1632345744	1	2019-11-05 15:57:09.794749	2019-11-06 12:52:14.142221	MiFAGA	77777777	112	rue1	JOYA	44444444	94	rue5	2	LOGISTIK	2	1450	20.859	3
1632345725	1	2019-11-05 15:15:38.860202	2019-11-06 12:29:39.961635	siaka	48414540	8	ayama	mie	47859621	63	rosier	1	radio	1	1250	12.805	3
1632345759	1	2019-11-05 16:27:23.091064	2019-11-06 12:04:32.970056	TOI KI	77777777	16	rue1	TOI TOI	44444444	20	rue5	1	chaises	1	1200	12.497	3
1632345713	1	2019-11-05 14:42:09.856556	2019-11-06 16:12:44.700239	fidel	49066609	39	lentorkro	infidel	34729708	66	BAD	1	Casier juridique  	2	1000	6.712	3
1632345757	1	2019-11-05 16:25:00.445197	2019-11-06 12:26:15.806265	Arafat	77777777	17	rue1	arafat	44444444	86	rue5	1	chaises	1	1400	21.405	3
1632345781	1	2019-11-18 14:36:58.355128	2019-11-18 15:11:14.316435	assa	77888145	2	rue10	binette	66704246	7	voyu	2	colis	1	1000	5.563	3
1632345770	1	2019-11-06 08:35:23.273641	2019-11-06 09:06:07.536511	madou	40916609	93	AVENU7	sidik	49098900	88	N'guoua	2	DES VELO	1	1350	16.97	3
1632345764	58	2019-11-05 17:33:40.920869	\N	kk	78788906	89	sib	uyu	89089878	33	station ivoire	1	bijoux or	2	1100	7.222	2
1632345782	1	2019-11-18 15:26:22.394402	2019-11-18 15:43:10.022189	lami	12696457	1	ETG	alpha	86367588	22	TRU	2	PORTABLE	1	1300	13.627	3
1632345753	1	2019-11-05 16:12:19.391964	2019-11-06 11:44:56.522651	HUM	77777777	29	rue1	HAIIIIIIIIII	44444444	115	rue5	1	JOURNAUX	1	1350	19.401	3
1632345768	1	2019-11-06 08:29:25.754407	2019-11-06 11:52:43.565295	amadou	08416609	96	ARO	sidik	09997877	71	N'guoua	2	ordinateur hp	1	1650	29.597	3
1632345775	82	2019-11-11 12:18:09.775219	\N	Dane Amani 	09783919	5	pharmacie dokui	angré 7eme tranche 	78184197	61	7eme tranche coopec	1	montre et bracelet 	2	1000	6.367	4
1632345783	1	2019-11-20 09:11:52.27076	\N	mohamed	67893414	94	rue 12	fatim	01365357	74	rue 5	2	pc	1	1700	30.557	2
1632345772	81	2019-11-10 22:26:33.65996	2019-11-12 16:17:40.106494	Dev	08701654	81	Boulangerie nouvelle Jérusalem 	Estelle	47725712	64	Collège saint viateur	2	Tasse	2	1500	23.14	3
1632345769	1	2019-11-06 08:34:12.956191	2019-11-06 11:53:55.401627	madou	40916609	93	AVENU7	sidik	49098900	71	N'guoua	2	DES VELO	1	1500	23.808	3
1632345776	82	2019-11-11 12:20:30.175154	2019-11-13 10:26:43.962826	Dane amani	09783919	5	pharmacie dokui 	yopougon 	07666784	72	yopougon toit rouge 	1	bracelet 	2	1250	14.051	3
1632345760	58	2019-11-05 17:15:09.239438	2019-11-06 11:54:04.842937	Kouassi 	01077484	4	mosquée el hadj	sekou	46620546	72	boulangerie la pacha 	1	sac â main	2	1400	22.116	3
1632345777	1	2019-11-11 15:33:53.106136	2019-11-13 10:26:53.154119	dja	21212121	20	rue3	SIKI	21212121	23	rue7	2	PAGNES	1	1000	4.982	3
1632345763	58	2019-11-05 17:29:10.747215	2019-11-06 11:56:48.928107	papi	03876767	66	sgbci	toto	07000084	76	pharmacie jk	1	montre	2	1250	14.339	3
1632345784	58	2019-11-22 08:30:56.966512	\N	kkk	01020304	20	rue a1	adh	01010101	37	église 	1	sac	1	1100	7.369	1
1632345762	58	2019-11-05 17:24:50.070478	2019-11-06 12:02:34.811455	km	09454567	50	je suis la	beti	89090989	113	église st pierre	1	valise	2	1450	23.465	3
1632345765	1	2019-11-06 08:18:27.507515	2019-11-06 12:06:36.313781	assie 	08416609	113	AERO	malik	09997877	7	N'guoua	2	sac 	1	1600	27.023	3
1632345773	1	2019-11-11 11:10:54.212944	2019-11-13 10:27:52.028663	ouattara	5252525_	67	selmer	aicha	20123210	41	riviera1	2	tass	1	1400	17.654	3
1632345766	1	2019-11-06 08:21:21.423311	2019-11-06 12:06:45.439291	amke 	08416609	103	AERO	sidik	09997877	115	N'guoua	2	ordinateur hp	1	1650	29.28	3
1632345767	1	2019-11-06 08:22:28.718779	2019-11-06 12:06:53.476555	amadou	08416609	96	ARO	sidik	09997877	115	N'guoua	2	ordinateur hp	1	1700	30.65	3
1632345774	82	2019-11-11 12:13:53.227479	2019-11-13 10:28:02.146813	Dane Amani	09783919	5	pharmacie dokui 	angré 7eme tranche	87775256	61	7eme tranche 	1	bracelet 	2	1000	6.367	3
1632345771	80	2019-11-08 14:25:50.186879	\N	pape Diouf 	49705128	115	Anyama château 	bakayoko	40979741	101	Marcory zone 4 La cité de golden hôtel	1	tunique ( ténue traditionnelle 	1	1600	30.526	4
1632345778	1	2019-11-13 10:27:30.759371	2019-11-13 16:09:56.260098	bou	33333333	20	rue0	SIKI	33333333	23	rue2	2	PAGNE	1	1000	4.982	3
1632345779	62	2019-11-18 10:14:41.897258	2019-11-18 10:50:05.723911	chansia	09876543	1	gare	Abdoul 	65765436	37	danga	1	pc	1	1250	14.407	3
1632345780	1	2019-11-18 14:14:34.844434	2019-11-18 14:33:17.105146	chamsiya	01924617	20	djeni kobenan	madjid	41109085	19	marche gouro	2	une robe	1	1000	5.388	3
\.


--
-- TOC entry 3121 (class 0 OID 18265)
-- Dependencies: 221
-- Data for Name: orders_history; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.orders_history (order_id, order_state_id, time_created) FROM stdin;
1632345254	1	2019-08-28 18:21:44.858294+00
1632345255	1	2019-08-31 12:47:25.921784+00
1632345255	2	2019-09-02 11:39:27.331556+00
1632345254	4	2019-09-02 17:36:24.191541+00
1632345261	1	2019-09-02 17:59:46.23906+00
1632345262	1	2019-09-04 12:09:45.332377+00
1632345261	2	2019-09-04 12:10:01.392644+00
1632345262	2	2019-09-04 12:10:20.782758+00
1632345262	4	2019-09-04 12:12:22.91096+00
1632345261	4	2019-09-04 12:12:39.657521+00
1632345263	1	2019-09-04 12:14:43.608344+00
1632345263	2	2019-09-04 12:15:23.517205+00
1632345264	1	2019-09-04 12:19:33.816044+00
1632345264	2	2019-09-04 12:19:51.462669+00
1632345265	1	2019-09-04 12:40:46.792753+00
1632345265	2	2019-09-04 12:42:21.661463+00
1632345266	1	2019-09-04 12:52:41.810056+00
1632345266	2	2019-09-04 12:53:19.525448+00
1632345267	1	2019-09-04 17:43:26.268644+00
1632345267	2	2019-09-04 17:43:59.824078+00
1632345268	1	2019-09-04 18:06:49.338769+00
1632345268	2	2019-09-04 18:07:17.120825+00
1632345269	1	2019-09-04 18:10:23.135509+00
1632345269	2	2019-09-04 18:10:49.598043+00
1632345270	1	2019-09-04 18:13:25.485368+00
1632345271	1	2019-09-04 18:18:29.849382+00
1632345272	1	2019-09-04 18:29:01.196788+00
1632345272	4	2019-09-04 18:49:50.219776+00
1632345271	4	2019-09-04 18:50:00.178083+00
1632345270	4	2019-09-04 18:50:09.05802+00
1632345273	1	2019-09-06 10:55:56.840043+00
1632345274	1	2019-09-06 11:01:58.480297+00
1632345275	1	2019-09-06 11:04:30.81904+00
1632345276	1	2019-09-06 11:07:37.870631+00
1632345277	1	2019-09-06 11:11:22.558455+00
1632345278	1	2019-09-06 11:14:45.157265+00
1632345278	2	2019-09-06 11:15:54.409057+00
1632345279	1	2019-09-06 11:18:38.499042+00
1632345279	2	2019-09-06 11:19:25.10026+00
1632345280	1	2019-09-06 11:21:34.259917+00
1632345280	2	2019-09-06 11:22:34.478891+00
1632345273	2	2019-09-06 12:00:56.859614+00
1632345277	2	2019-09-06 12:06:31.47464+00
1632345274	2	2019-09-06 12:10:32.904853+00
1632345276	2	2019-09-06 12:12:39.934827+00
1632345275	2	2019-09-06 12:14:35.129243+00
1632345281	1	2019-09-06 12:18:03.38074+00
1632345281	2	2019-09-06 12:40:08.404267+00
1632345282	1	2019-09-08 09:59:48.665924+00
1632345283	1	2019-09-09 12:47:29.311177+00
1632345284	1	2019-09-10 12:00:20.133105+00
1632345285	1	2019-09-10 12:06:14.654474+00
1632345286	1	2019-09-10 12:09:46.330341+00
1632345282	2	2019-09-10 12:15:09.000511+00
1632345283	2	2019-09-10 12:15:14.531126+00
1632345284	2	2019-09-10 12:15:21.509418+00
1632345285	2	2019-09-10 12:15:25.270316+00
1632345286	2	2019-09-10 12:15:28.841876+00
1632345287	1	2019-09-10 12:18:16.367255+00
1632345287	2	2019-09-10 12:18:42.549076+00
1632345288	1	2019-09-10 15:11:45.741009+00
1632345289	1	2019-09-19 08:58:52.639149+00
1632345290	1	2019-09-19 09:02:05.713879+00
1632345288	2	2019-09-19 09:10:18.271053+00
1632345289	2	2019-09-19 09:19:01.50414+00
1632345291	1	2019-09-19 11:08:27.67494+00
1632345292	1	2019-09-19 11:08:40.063209+00
1632345293	1	2019-09-19 11:08:40.946634+00
1632345294	1	2019-09-19 11:09:05.174667+00
1632345295	1	2019-09-19 11:33:04.075556+00
1632345296	1	2019-09-19 11:34:15.254882+00
1632345297	1	2019-09-19 11:38:29.815157+00
1632345298	1	2019-09-19 12:33:54.568034+00
1632345299	1	2019-09-19 14:57:55.636968+00
1632345300	1	2019-09-19 15:13:42.639408+00
1632345301	1	2019-09-19 21:28:53.48278+00
1632345302	1	2019-09-20 09:50:32.881911+00
1632345302	2	2019-09-20 10:15:23.790654+00
1632345301	2	2019-09-20 10:16:03.067947+00
1632345300	2	2019-09-20 10:16:28.181232+00
1632345299	2	2019-09-20 10:16:52.226261+00
1632345298	2	2019-09-20 10:17:57.280214+00
1632345303	1	2019-09-20 10:20:50.471287+00
1632345303	2	2019-09-20 10:21:03.226587+00
1632345304	1	2019-09-20 10:23:08.728025+00
1632345304	2	2019-09-20 10:23:25.573154+00
1632345305	1	2019-09-20 10:24:54.528094+00
1632345305	2	2019-09-20 10:25:06.585503+00
1632345306	1	2019-09-20 11:08:13.441193+00
1632345306	2	2019-09-20 11:08:26.943226+00
1632345307	1	2019-09-20 11:11:51.602845+00
1632345307	2	2019-09-20 11:11:59.577179+00
1632345308	1	2019-09-20 11:17:04.681917+00
1632345308	2	2019-09-20 11:17:42.66152+00
1632345309	1	2019-09-20 11:20:59.67784+00
1632345309	2	2019-09-20 11:21:10.968557+00
1632345310	1	2019-09-20 11:24:10.58582+00
1632345310	2	2019-09-20 11:24:25.806692+00
1632345311	1	2019-09-20 11:49:07.964631+00
1632345312	1	2019-09-20 11:49:14.242111+00
1632345313	1	2019-09-20 11:49:18.788869+00
1632345314	1	2019-09-20 11:51:18.035774+00
1632345315	1	2019-09-20 11:52:24.642174+00
1632345316	1	2019-09-20 11:56:29.491021+00
1632345316	2	2019-09-20 11:56:56.900923+00
1632345315	2	2019-09-20 11:57:12.553303+00
1632345314	2	2019-09-20 11:57:25.455992+00
1632345297	2	2019-09-20 11:57:41.245391+00
1632345313	2	2019-09-20 11:58:01.142884+00
1632345293	2	2019-09-20 11:58:09.463043+00
1632345311	2	2019-09-20 11:58:13.163703+00
1632345312	2	2019-09-20 11:58:28.240688+00
1632345317	1	2019-09-20 12:34:40.312326+00
1632345318	1	2019-09-20 12:35:03.599824+00
1632345319	1	2019-09-20 12:35:23.398379+00
1632345320	1	2019-09-20 12:35:23.706848+00
1632345321	1	2019-09-20 12:35:53.81335+00
1632345322	1	2019-09-20 12:36:13.413243+00
1632345322	2	2019-09-20 12:36:29.350142+00
1632345317	2	2019-09-20 12:36:45.345204+00
1632345321	2	2019-09-20 12:37:18.92654+00
1632345320	2	2019-09-20 12:37:25.192943+00
1632345319	2	2019-09-20 12:37:44.746984+00
1632345322	4	2019-09-20 12:37:46.06559+00
1632345318	2	2019-09-20 12:39:04.419642+00
1632345323	1	2019-09-20 14:57:19.915094+00
1632345323	2	2019-09-20 14:59:23.600012+00
1632345324	1	2019-09-20 16:02:58.685237+00
1632345324	2	2019-09-20 16:06:03.995984+00
1632345325	1	2019-09-20 16:24:45.387804+00
1632345325	2	2019-09-20 16:26:36.79937+00
1632345326	1	2019-09-23 09:06:09.884421+00
1632345326	2	2019-09-23 09:06:36.318132+00
1632345327	1	2019-09-23 11:10:32.038187+00
1632345328	1	2019-09-23 11:12:28.65296+00
1632345329	1	2019-09-23 11:12:40.375053+00
1632345330	1	2019-09-23 11:14:35.848983+00
1632345330	2	2019-09-23 11:23:47.689737+00
1632345329	2	2019-09-23 11:31:04.150393+00
1632345328	2	2019-09-23 11:48:43.816554+00
1632345327	2	2019-09-23 11:56:59.980304+00
1632345331	1	2019-09-23 14:32:43.020709+00
1632345331	2	2019-09-23 14:34:41.215583+00
1632345332	1	2019-09-24 10:47:42.688851+00
1632345333	1	2019-09-24 10:47:43.228732+00
1632345334	1	2019-09-24 10:49:35.729461+00
1632345335	1	2019-09-24 10:54:07.012821+00
1632345332	2	2019-09-24 11:07:13.448685+00
1632345333	2	2019-09-24 11:07:30.497954+00
1632345334	2	2019-09-24 11:07:40.398333+00
1632345335	2	2019-09-24 11:07:53.261027+00
1632345336	1	2019-09-24 12:09:39.388588+00
1632345336	2	2019-09-24 12:09:54.394122+00
1632345337	1	2019-09-24 12:14:47.920723+00
1632345337	2	2019-09-24 12:15:11.864049+00
1632345338	1	2019-09-24 12:18:20.492814+00
1632345338	2	2019-09-24 12:18:37.415384+00
1632345339	1	2019-09-24 12:21:21.740217+00
1632345339	2	2019-09-24 12:21:38.434061+00
1632345340	1	2019-09-24 13:56:08.085829+00
1632345341	1	2019-09-24 13:56:52.447046+00
1632345342	1	2019-09-24 13:57:08.117885+00
1632345343	1	2019-09-24 13:57:38.864023+00
1632345344	1	2019-09-24 13:57:47.004659+00
1632345341	2	2019-09-24 13:58:27.40547+00
1632345340	2	2019-09-24 13:58:30.017456+00
1632345344	2	2019-09-24 13:58:31.621822+00
1632345342	2	2019-09-24 13:58:42.169843+00
1632345345	1	2019-09-24 13:59:34.735021+00
1632345345	2	2019-09-24 14:00:46.0228+00
1632345343	2	2019-09-24 14:00:50.476+00
1632345346	1	2019-09-24 14:05:59.301703+00
1632345347	1	2019-09-24 14:07:54.61122+00
1632345348	1	2019-09-24 14:08:37.594691+00
1632345349	1	2019-09-24 14:08:43.612676+00
1632345348	2	2019-09-24 14:08:52.791437+00
1632345347	2	2019-09-24 14:08:54.073324+00
1632345350	1	2019-09-24 14:09:05.358717+00
1632345346	2	2019-09-24 14:10:21.68543+00
1632345350	2	2019-09-24 14:10:22.682452+00
1632345349	2	2019-09-24 14:10:47.293882+00
1632345351	1	2019-09-24 14:32:11.256954+00
1632345352	1	2019-09-24 14:33:38.480474+00
1632345352	2	2019-09-24 14:36:20.951852+00
1632345351	2	2019-09-24 14:36:24.380384+00
1632345353	1	2019-09-24 15:26:10.768986+00
1632345353	4	2019-09-24 15:29:02.320717+00
1632345354	1	2019-09-24 15:31:02.31404+00
1632345354	4	2019-09-24 15:35:40.811351+00
1632345355	1	2019-09-24 15:38:21.694013+00
1632345355	2	2019-09-24 16:09:09.931906+00
1632345356	1	2019-09-24 16:13:01.673889+00
1632345356	2	2019-09-24 16:13:29.201694+00
1632345357	1	2019-09-24 16:27:36.032623+00
1632345357	2	2019-09-24 16:27:59.020262+00
1632345358	1	2019-09-25 09:11:20.678743+00
1632345358	2	2019-09-25 09:17:59.786022+00
1632345359	1	2019-09-25 09:25:42.973326+00
1632345359	2	2019-09-25 09:26:26.45338+00
1632345360	1	2019-09-25 10:09:32.622915+00
1632345360	2	2019-09-25 10:11:01.60496+00
1632345361	1	2019-09-25 10:23:38.663077+00
1632345361	2	2019-09-25 10:24:42.04312+00
1632345362	1	2019-09-25 10:47:49.361568+00
1632345363	1	2019-09-25 10:47:57.567012+00
1632345363	2	2019-09-25 10:48:35.873764+00
1632345364	1	2019-09-25 10:48:46.289503+00
1632345362	2	2019-09-25 10:48:49.194105+00
1632345364	2	2019-09-25 10:49:16.784998+00
1632345365	1	2019-09-25 10:49:30.378758+00
1632345365	2	2019-09-25 10:49:48.60687+00
1632345366	1	2019-09-25 10:49:58.753602+00
1632345366	2	2019-09-25 10:50:55.248311+00
1632345367	1	2019-09-25 11:02:23.79552+00
1632345367	2	2019-09-25 11:02:47.203427+00
1632345368	1	2019-09-25 11:08:05.343953+00
1632345368	2	2019-09-25 11:08:25.997323+00
1632345369	1	2019-09-25 11:13:13.626841+00
1632345370	1	2019-09-25 11:13:23.243477+00
1632345370	2	2019-09-25 11:13:37.135394+00
1632345369	2	2019-09-25 11:14:07.882896+00
1632345371	1	2019-09-25 11:14:29.453112+00
1632345372	1	2019-09-25 11:14:54.76226+00
1632345371	2	2019-09-25 11:14:59.206183+00
1632345372	2	2019-09-25 11:15:42.102931+00
1632345373	1	2019-09-25 11:21:32.555895+00
1632345373	2	2019-09-25 11:21:57.774973+00
1632345374	1	2019-09-25 11:33:56.349592+00
1632345375	1	2019-09-25 11:34:02.550225+00
1632345374	2	2019-09-25 11:34:08.488889+00
1632345376	1	2019-09-25 11:34:11.830147+00
1632345375	2	2019-09-25 11:34:36.816739+00
1632345376	2	2019-09-25 11:34:51.133956+00
1632345377	1	2019-09-25 11:34:55.254295+00
1632345377	2	2019-09-25 11:35:33.257968+00
1632345378	1	2019-09-25 12:15:28.505791+00
1632345378	2	2019-09-25 12:17:26.777919+00
1632345379	1	2019-09-25 12:23:23.108301+00
1632345379	2	2019-09-25 12:23:35.255642+00
1632345380	1	2019-09-25 12:32:29.81162+00
1632345380	2	2019-09-25 12:33:01.634853+00
1632345381	1	2019-09-25 12:43:19.867103+00
1632345381	2	2019-09-25 12:43:42.148773+00
1632345382	1	2019-09-25 12:51:33.195624+00
1632345382	2	2019-09-25 12:51:41.223821+00
1632345383	1	2019-09-25 13:39:00.137654+00
1632345383	2	2019-09-25 13:39:26.219748+00
1632345384	1	2019-09-25 14:44:58.60769+00
1632345385	1	2019-09-25 14:45:54.838988+00
1632345386	1	2019-09-25 14:46:18.767811+00
1632345384	2	2019-09-25 14:46:25.514533+00
1632345387	1	2019-09-25 14:46:39.45261+00
1632345385	2	2019-09-25 14:47:10.091332+00
1632345387	2	2019-09-25 14:47:36.291114+00
1632345386	2	2019-09-25 14:47:50.693663+00
1632345388	1	2019-09-25 15:01:41.687722+00
1632345389	1	2019-09-25 15:02:46.112537+00
1632345389	2	2019-09-25 15:03:22.41762+00
1632345388	2	2019-09-25 15:04:34.937498+00
1632345390	1	2019-09-25 15:05:02.526853+00
1632345390	2	2019-09-25 15:05:16.913834+00
1632345391	1	2019-09-25 15:16:53.926074+00
1632345392	1	2019-09-25 15:18:11.212542+00
1632345393	1	2019-09-25 15:18:14.254181+00
1632345394	1	2019-09-25 15:19:04.81171+00
1632345393	2	2019-09-25 15:19:14.560536+00
1632345392	4	2019-09-25 15:20:39.821063+00
1632345391	2	2019-09-25 15:21:18.693461+00
1632345395	1	2019-09-25 15:22:15.40451+00
1632345396	1	2019-09-25 15:23:02.414835+00
1632345394	2	2019-09-25 15:23:18.444037+00
1632345396	2	2019-09-25 15:23:37.984155+00
1632345395	2	2019-09-25 15:23:49.595769+00
1632345397	1	2019-09-25 15:46:23.908788+00
1632345398	1	2019-09-25 15:47:01.117859+00
1632345397	2	2019-09-25 15:47:19.070721+00
1632345398	2	2019-09-25 15:47:24.273093+00
1632345399	1	2019-09-25 15:48:45.166909+00
1632345400	1	2019-09-25 15:49:37.602534+00
1632345400	2	2019-09-25 15:50:23.971511+00
1632345401	1	2019-09-25 15:51:19.740936+00
1632345401	2	2019-09-25 15:51:57.275465+00
1632345402	1	2019-09-25 15:54:04.941128+00
1632345402	2	2019-09-25 15:56:28.493768+00
1632345399	2	2019-09-25 16:01:55.355963+00
1632345403	1	2019-09-25 16:03:46.836419+00
1632345404	1	2019-09-25 16:04:30.568098+00
1632345405	1	2019-09-25 16:04:32.941534+00
1632345406	1	2019-09-25 16:04:52.586047+00
1632345407	1	2019-09-25 16:05:03.731038+00
1632345403	2	2019-09-25 16:05:30.083657+00
1632345408	1	2019-09-25 16:05:46.813291+00
1632345409	1	2019-09-25 16:05:50.498813+00
1632345408	2	2019-09-25 16:06:04.831741+00
1632345404	2	2019-09-25 16:06:23.314787+00
1632345406	2	2019-09-25 16:06:32.08708+00
1632345407	2	2019-09-25 16:06:34.704267+00
1632345410	1	2019-09-25 16:06:35.739801+00
1632345409	2	2019-09-25 16:06:38.148474+00
1632345410	2	2019-09-25 16:06:45.1768+00
1632345405	2	2019-09-25 16:07:16.330711+00
1632345411	1	2019-09-25 16:08:21.353112+00
1632345412	1	2019-09-25 16:09:40.191621+00
1632345412	2	2019-09-25 16:09:59.681227+00
1632345413	1	2019-09-25 16:10:14.45499+00
1632345413	2	2019-09-25 16:11:10.074474+00
1632345411	2	2019-09-25 16:11:22.666792+00
1632345414	1	2019-09-25 16:12:18.550179+00
1632345414	2	2019-09-25 16:12:42.706506+00
1632345415	1	2019-09-25 16:40:14.999444+00
1632345416	1	2019-09-25 16:40:50.026289+00
1632345417	1	2019-09-25 16:40:59.322939+00
1632345415	2	2019-09-25 16:41:16.346391+00
1632345417	2	2019-09-25 16:41:26.726519+00
1632345416	2	2019-09-25 16:41:31.12761+00
1632345418	1	2019-09-25 16:43:06.800817+00
1632345419	1	2019-09-25 16:43:22.523478+00
1632345420	1	2019-09-25 16:44:17.299189+00
1632345421	1	2019-09-25 16:44:19.541961+00
1632345421	2	2019-09-25 16:44:50.155218+00
1632345418	2	2019-09-25 16:44:50.372124+00
1632345420	2	2019-09-25 16:45:11.494686+00
1632345422	1	2019-09-25 16:46:43.682302+00
1632345422	2	2019-09-25 16:47:07.626021+00
1632345419	4	2019-09-25 16:47:42.048523+00
1632345423	1	2019-09-25 16:57:22.810044+00
1632345424	1	2019-09-25 16:58:04.825445+00
1632345425	1	2019-09-25 16:58:57.360947+00
1632345426	1	2019-09-25 16:59:12.177885+00
1632345426	2	2019-09-25 17:02:18.471075+00
1632345425	2	2019-09-25 17:04:34.198997+00
1632345424	2	2019-09-25 17:07:30.899502+00
1632345423	2	2019-09-25 17:12:49.03217+00
1632345427	1	2019-09-26 14:16:01.425007+00
1632345428	1	2019-09-26 14:16:50.30696+00
1632345428	2	2019-09-26 14:17:53.93539+00
1632345427	2	2019-09-26 14:18:26.237269+00
1632345428	4	2019-09-26 14:21:57.70504+00
1632345429	1	2019-09-26 14:25:25.295079+00
1632345429	2	2019-09-26 14:26:29.635994+00
1632345430	1	2019-09-26 14:40:12.398133+00
1632345430	2	2019-09-26 14:42:00.038512+00
1632345431	1	2019-09-26 14:59:01.806966+00
1632345431	2	2019-09-26 14:59:17.853836+00
1632345432	1	2019-09-26 15:20:28.507232+00
1632345432	2	2019-09-26 15:21:26.064531+00
1632345433	1	2019-09-26 16:05:36.583672+00
1632345433	2	2019-09-26 16:05:56.451376+00
1632345434	1	2019-09-26 17:17:59.50052+00
1632345434	2	2019-09-26 17:18:27.665418+00
1632345435	1	2019-09-27 10:49:31.773639+00
1632345436	1	2019-09-27 10:52:39.072206+00
1632345437	1	2019-09-27 10:54:14.350408+00
1632345436	2	2019-09-27 10:54:19.286892+00
1632345438	1	2019-09-27 10:55:12.495908+00
1632345438	2	2019-09-27 10:55:26.845576+00
1632345437	2	2019-09-27 10:55:27.916531+00
1632345435	2	2019-09-27 10:56:00.432205+00
1632345437	4	2019-09-27 10:56:12.73128+00
1632345439	1	2019-09-27 10:57:44.3237+00
1632345439	2	2019-09-27 10:58:02.201434+00
1632345440	1	2019-09-27 11:07:59.457855+00
1632345441	1	2019-09-27 11:08:01.423327+00
1632345440	2	2019-09-27 11:08:25.302528+00
1632345441	2	2019-09-27 11:08:34.568168+00
1632345442	1	2019-09-27 11:08:39.465058+00
1632345442	2	2019-09-27 11:08:52.059481+00
1632345443	1	2019-09-27 11:09:24.049465+00
1632345443	2	2019-09-27 11:10:32.84884+00
1632345444	1	2019-09-27 11:14:56.948055+00
1632345444	2	2019-09-27 11:15:27.481746+00
1632345445	1	2019-09-27 11:19:26.090695+00
1632345446	1	2019-09-27 11:19:45.733318+00
1632345445	2	2019-09-27 11:19:49.169016+00
1632345447	1	2019-09-27 11:19:56.162053+00
1632345447	2	2019-09-27 11:20:17.318843+00
1632345448	1	2019-09-27 11:20:18.016615+00
1632345446	2	2019-09-27 11:20:37.676574+00
1632345448	2	2019-09-27 11:20:45.204357+00
1632345449	1	2019-09-27 11:29:40.847879+00
1632345450	1	2019-09-27 11:30:03.28363+00
1632345451	1	2019-09-27 11:30:20.187016+00
1632345452	1	2019-09-27 11:30:39.369526+00
1632345449	2	2019-09-27 11:30:41.045132+00
1632345452	2	2019-09-27 11:30:50.904098+00
1632345451	2	2019-09-27 11:30:51.371699+00
1632345450	2	2019-09-27 11:30:54.553025+00
1632345453	1	2019-09-27 11:31:11.81273+00
1632345454	1	2019-09-27 11:31:14.341719+00
1632345453	2	2019-09-27 11:31:38.008453+00
1632345455	1	2019-09-27 11:32:34.77472+00
1632345455	2	2019-09-27 11:32:51.765544+00
1632345456	1	2019-09-27 11:32:57.400333+00
1632345456	2	2019-09-27 11:33:18.815448+00
1632345454	2	2019-09-27 11:33:27.702106+00
1632345457	1	2019-09-27 11:43:30.381459+00
1632345457	2	2019-09-27 11:43:57.297319+00
1632345458	1	2019-09-27 11:51:03.124081+00
1632345458	2	2019-09-27 11:51:22.801596+00
1632345459	1	2019-09-27 11:51:28.12844+00
1632345460	1	2019-09-27 11:51:39.834339+00
1632345461	1	2019-09-27 11:51:46.479928+00
1632345462	1	2019-09-27 11:51:46.89861+00
1632345463	1	2019-09-27 11:51:57.71378+00
1632345460	2	2019-09-27 11:51:59.080177+00
1632345461	2	2019-09-27 11:52:13.681024+00
1632345459	2	2019-09-27 11:52:32.467785+00
1632345462	2	2019-09-27 11:52:36.69779+00
1632345463	2	2019-09-27 11:52:45.814972+00
1632345464	1	2019-09-27 11:53:17.804846+00
1632345465	1	2019-09-27 11:53:22.732697+00
1632345466	1	2019-09-27 11:53:45.563512+00
1632345466	2	2019-09-27 11:54:21.677342+00
1632345465	2	2019-09-27 11:54:28.119149+00
1632345464	2	2019-09-27 11:54:36.645132+00
1632345467	1	2019-09-27 11:57:14.162072+00
1632345467	2	2019-09-27 11:57:23.967267+00
1632345468	1	2019-09-27 12:05:08.159888+00
1632345469	1	2019-09-27 12:05:12.167176+00
1632345468	2	2019-09-27 12:05:27.67371+00
1632345469	2	2019-09-27 12:05:34.106169+00
1632345470	1	2019-09-27 12:05:42.98031+00
1632345471	1	2019-09-27 12:05:45.893967+00
1632345472	1	2019-09-27 12:06:10.465735+00
1632345473	1	2019-09-27 12:06:16.438556+00
1632345474	1	2019-09-27 12:06:21.914456+00
1632345473	2	2019-09-27 12:06:35.967497+00
1632345471	2	2019-09-27 12:06:37.07534+00
1632345474	2	2019-09-27 12:06:45.874881+00
1632345475	1	2019-09-27 12:06:57.909604+00
1632345475	2	2019-09-27 12:07:22.721627+00
1632345470	2	2019-09-27 12:07:50.032826+00
1632345476	1	2019-09-27 12:07:51.590471+00
1632345477	1	2019-09-27 12:07:55.281993+00
1632345472	2	2019-09-27 12:08:02.629179+00
1632345476	2	2019-09-27 12:08:20.949459+00
1632345477	2	2019-09-27 12:10:41.06749+00
1632345478	1	2019-09-27 14:11:15.16253+00
1632345479	1	2019-09-27 14:11:16.013162+00
1632345480	1	2019-09-27 14:11:35.939158+00
1632345481	1	2019-09-27 14:11:36.538238+00
1632345482	1	2019-09-27 14:11:49.032363+00
1632345483	1	2019-09-27 14:12:14.382233+00
1632345478	2	2019-09-27 14:12:23.819168+00
1632345480	2	2019-09-27 14:12:23.959092+00
1632345482	2	2019-09-27 14:12:31.186168+00
1632345484	1	2019-09-27 14:12:33.24212+00
1632345483	2	2019-09-27 14:12:39.249808+00
1632345485	1	2019-09-27 14:12:43.818463+00
1632345486	1	2019-09-27 14:12:45.293034+00
1632345481	2	2019-09-27 14:12:53.494647+00
1632345484	2	2019-09-27 14:13:01.91653+00
1632345479	2	2019-09-27 14:13:21.80852+00
1632345487	1	2019-09-27 14:13:33.178945+00
1632345488	1	2019-09-27 14:13:37.434819+00
1632345489	1	2019-09-27 14:13:43.209871+00
1632345487	2	2019-09-27 14:13:44.392778+00
1632345488	2	2019-09-27 14:13:48.01554+00
1632345486	2	2019-09-27 14:13:53.984213+00
1632345489	2	2019-09-27 14:14:03.776451+00
1632345490	1	2019-09-27 14:14:07.166898+00
1632345485	2	2019-09-27 14:14:07.194878+00
1632345490	2	2019-09-27 14:14:21.601895+00
1632345491	1	2019-09-27 14:15:49.188025+00
1632345492	1	2019-09-27 14:17:18.99825+00
1632345491	2	2019-09-27 14:17:29.379679+00
1632345492	2	2019-09-27 14:18:29.610958+00
1632345493	1	2019-09-27 14:24:27.009995+00
1632345493	2	2019-09-27 14:24:43.157871+00
1632345494	1	2019-09-27 14:34:46.17584+00
1632345494	4	2019-09-27 14:35:35.836321+00
1632345495	1	2019-09-27 14:39:04.036163+00
1632345496	1	2019-09-27 14:39:56.437995+00
1632345497	1	2019-09-27 14:40:18.337736+00
1632345498	1	2019-09-27 14:40:21.551537+00
1632345499	1	2019-09-27 14:40:22.934026+00
1632345500	1	2019-09-27 14:40:35.649355+00
1632345498	2	2019-09-27 14:40:45.147452+00
1632345501	1	2019-09-27 14:40:46.92109+00
1632345502	1	2019-09-27 14:40:54.611225+00
1632345503	1	2019-09-27 14:40:55.777753+00
1632345504	1	2019-09-27 14:40:57.496188+00
1632345500	2	2019-09-27 14:40:58.73074+00
1632345499	2	2019-09-27 14:41:00.896137+00
1632345504	2	2019-09-27 14:41:04.811546+00
1632345503	2	2019-09-27 14:41:07.482057+00
1632345502	2	2019-09-27 14:41:09.544044+00
1632345505	1	2019-09-27 14:41:18.850681+00
1632345501	2	2019-09-27 14:41:24.129421+00
1632345505	2	2019-09-27 14:41:24.947468+00
1632345497	2	2019-09-27 14:41:29.071673+00
1632345506	1	2019-09-27 14:42:07.078689+00
1632345506	2	2019-09-27 14:42:17.285458+00
1632345507	1	2019-09-27 14:42:30.776993+00
1632345508	1	2019-09-27 14:42:37.013648+00
1632345507	2	2019-09-27 14:42:45.150204+00
1632345508	2	2019-09-27 14:43:01.373184+00
1632345509	1	2019-09-27 14:43:22.00434+00
1632345510	1	2019-09-27 14:43:31.528127+00
1632345496	2	2019-09-27 14:43:32.713782+00
1632345495	2	2019-09-27 14:43:39.221268+00
1632345510	2	2019-09-27 14:43:52.195185+00
1632345511	1	2019-09-27 14:44:31.321428+00
1632345511	2	2019-09-27 14:44:55.205127+00
1632345512	1	2019-09-27 14:46:16.670779+00
1632345512	2	2019-09-27 14:46:44.169712+00
1632345509	2	2019-09-27 14:47:18.089109+00
1632345513	1	2019-09-27 14:47:40.877532+00
1632345514	1	2019-09-27 14:47:47.542365+00
1632345514	2	2019-09-27 14:48:00.172967+00
1632345513	2	2019-09-27 14:48:11.152232+00
1632345515	1	2019-09-27 14:48:55.316214+00
1632345515	2	2019-09-27 14:49:20.551254+00
1632345516	1	2019-09-27 15:06:03.125287+00
1632345516	2	2019-09-27 15:06:19.362277+00
1632345517	1	2019-09-27 15:25:56.911799+00
1632345517	2	2019-09-27 15:26:09.457692+00
1632345518	1	2019-09-27 15:34:46.062979+00
1632345518	2	2019-09-27 15:46:21.147561+00
1632345519	1	2019-09-27 16:10:18.271431+00
1632345519	2	2019-09-27 16:10:48.649727+00
1632345520	1	2019-09-27 16:12:00.429568+00
1632345520	2	2019-09-27 16:12:09.792711+00
1632345521	1	2019-09-27 16:12:49.074302+00
1632345521	2	2019-09-27 16:13:03.908091+00
1632345522	1	2019-09-27 16:16:34.032981+00
1632345522	2	2019-09-27 16:16:51.77485+00
1632345523	1	2019-09-27 16:19:13.568908+00
1632345523	2	2019-09-27 16:19:24.938552+00
1632345524	1	2019-09-27 16:20:10.49951+00
1632345524	2	2019-09-27 16:20:31.710616+00
1632345525	1	2019-09-27 16:41:54.455244+00
1632345525	2	2019-09-27 16:43:42.265483+00
1632345526	1	2019-09-27 16:46:31.682656+00
1632345526	2	2019-09-27 16:46:52.365116+00
1632345527	1	2019-09-27 17:11:36.241944+00
1632345527	2	2019-09-27 17:12:22.129445+00
1632345528	1	2019-09-30 10:23:27.845579+00
1632345528	2	2019-09-30 10:24:29.862106+00
1632345529	1	2019-09-30 10:54:01.270261+00
1632345529	2	2019-09-30 10:57:56.618214+00
1632345530	1	2019-09-30 12:01:34.376026+00
1632345530	2	2019-09-30 12:02:08.287617+00
1632345531	1	2019-09-30 12:08:21.654146+00
1632345532	1	2019-09-30 12:08:59.546966+00
1632345531	2	2019-09-30 12:09:02.579228+00
1632345532	2	2019-09-30 12:09:20.826777+00
1632345533	1	2019-10-01 14:32:01.500744+00
1632345533	2	2019-10-01 14:32:32.249461+00
1632345534	1	2019-10-01 14:41:31.893757+00
1632345534	2	2019-10-01 14:43:36.110679+00
1632345535	1	2019-10-01 15:42:14.56296+00
1632345535	2	2019-10-01 15:42:32.087541+00
1632345536	1	2019-10-02 09:34:04.692089+00
1632345536	4	2019-10-02 09:35:36.490259+00
1632345537	1	2019-10-05 08:55:48.719233+00
1632345538	1	2019-10-05 11:46:38.049824+00
1632345539	1	2019-10-05 11:49:23.535134+00
1632345538	2	2019-10-05 13:39:18.486155+00
1632345539	2	2019-10-05 13:50:40.67358+00
1632345540	1	2019-10-06 14:23:22.507401+00
1632345540	2	2019-10-07 13:52:37.080019+00
1632345537	2	2019-10-07 13:52:43.915002+00
1632345541	1	2019-10-07 14:23:46.228116+00
1632345542	1	2019-10-07 14:23:53.231014+00
1632345543	1	2019-10-07 14:26:33.482183+00
1632345544	1	2019-10-07 14:26:55.031699+00
1632345545	1	2019-10-07 14:27:43.677768+00
1632345546	1	2019-10-07 14:28:09.696719+00
1632345547	1	2019-10-07 14:29:48.096481+00
1632345548	1	2019-10-07 14:29:57.554015+00
1632345549	1	2019-10-07 14:31:24.219693+00
1632345550	1	2019-10-07 14:33:19.604431+00
1632345550	2	2019-10-07 14:36:09.35664+00
1632345549	2	2019-10-07 14:36:16.61298+00
1632345548	2	2019-10-07 14:36:22.241391+00
1632345547	2	2019-10-07 14:36:36.147847+00
1632345546	2	2019-10-07 14:36:41.51351+00
1632345545	2	2019-10-07 14:36:48.691826+00
1632345544	2	2019-10-07 14:36:57.274243+00
1632345543	2	2019-10-07 14:37:03.854204+00
1632345542	2	2019-10-07 14:37:09.453615+00
1632345541	2	2019-10-07 14:37:14.04818+00
1632345551	1	2019-10-08 10:10:53.022683+00
1632345551	2	2019-10-08 10:11:36.612038+00
1632345552	1	2019-10-08 10:27:10.105105+00
1632345553	1	2019-10-08 10:27:30.919166+00
1632345554	1	2019-10-08 10:27:49.68223+00
1632345555	1	2019-10-08 10:27:51.536521+00
1632345556	1	2019-10-08 10:28:13.796826+00
1632345557	1	2019-10-08 10:28:37.036932+00
1632345558	1	2019-10-08 10:29:05.802612+00
1632345559	1	2019-10-08 10:29:17.373018+00
1632345558	2	2019-10-08 10:29:31.09792+00
1632345560	1	2019-10-08 10:29:45.557436+00
1632345561	1	2019-10-08 10:30:17.381241+00
1632345562	1	2019-10-08 10:30:38.191788+00
1632345563	1	2019-10-08 10:30:47.395799+00
1632345564	1	2019-10-08 10:31:27.253313+00
1632345565	1	2019-10-08 10:31:28.978518+00
1632345565	2	2019-10-08 10:31:37.500366+00
1632345566	1	2019-10-08 10:32:25.905438+00
1632345567	1	2019-10-08 10:32:45.7258+00
1632345567	2	2019-10-08 10:33:05.611465+00
1632345568	1	2019-10-08 10:33:59.463331+00
1632345568	2	2019-10-08 10:34:06.905684+00
1632345569	1	2019-10-08 10:34:40.466995+00
1632345570	1	2019-10-08 10:34:59.667683+00
1632345571	1	2019-10-08 10:35:25.101236+00
1632345571	2	2019-10-08 10:35:37.622375+00
1632345572	1	2019-10-08 10:37:28.57444+00
1632345572	2	2019-10-08 10:37:44.78131+00
1632345570	2	2019-10-08 10:37:52.121301+00
1632345569	2	2019-10-08 10:37:59.258874+00
1632345566	2	2019-10-08 10:38:10.287799+00
1632345564	2	2019-10-08 10:38:14.370487+00
1632345573	1	2019-10-08 10:38:20.426244+00
1632345563	2	2019-10-08 10:38:23.118147+00
1632345562	2	2019-10-08 10:38:29.079497+00
1632345561	2	2019-10-08 10:38:37.294424+00
1632345560	2	2019-10-08 10:38:42.289823+00
1632345559	2	2019-10-08 10:38:48.555438+00
1632345574	1	2019-10-08 10:39:05.428049+00
1632345557	2	2019-10-08 10:39:07.103791+00
1632345573	2	2019-10-08 10:39:11.984409+00
1632345556	2	2019-10-08 10:39:15.840562+00
1632345574	2	2019-10-08 10:39:16.783584+00
1632345555	2	2019-10-08 10:39:19.953491+00
1632345575	1	2019-10-08 10:52:59.371733+00
1632345575	2	2019-10-08 10:53:43.816452+00
1632345554	2	2019-10-08 10:54:44.06772+00
1632345553	2	2019-10-08 10:54:53.4327+00
1632345552	2	2019-10-08 10:55:01.247084+00
1632345576	1	2019-10-08 11:08:42.909935+00
1632345576	2	2019-10-08 11:09:14.183524+00
1632345577	1	2019-10-08 11:09:24.767072+00
1632345578	1	2019-10-08 11:09:38.10091+00
1632345579	1	2019-10-08 11:09:47.072819+00
1632345580	1	2019-10-08 11:09:54.564463+00
1632345581	1	2019-10-08 11:10:10.453604+00
1632345582	1	2019-10-08 11:10:39.470338+00
1632345583	1	2019-10-08 11:11:20.445857+00
1632345584	1	2019-10-08 11:11:22.400827+00
1632345585	1	2019-10-08 11:11:37.327908+00
1632345584	2	2019-10-08 11:11:39.787598+00
1632345586	1	2019-10-08 11:12:02.347026+00
1632345587	1	2019-10-08 11:12:11.961955+00
1632345588	1	2019-10-08 11:12:16.852103+00
1632345587	2	2019-10-08 11:12:38.624397+00
1632345589	1	2019-10-08 11:12:38.729395+00
1632345590	1	2019-10-08 11:12:52.006225+00
1632345591	1	2019-10-08 11:12:54.73388+00
1632345592	1	2019-10-08 11:12:59.611957+00
1632345593	1	2019-10-08 11:13:04.179905+00
1632345591	2	2019-10-08 11:13:13.274587+00
1632345592	2	2019-10-08 11:13:15.652317+00
1632345590	2	2019-10-08 11:13:16.925799+00
1632345593	2	2019-10-08 11:13:18.642535+00
1632345589	2	2019-10-08 11:13:24.601237+00
1632345588	2	2019-10-08 11:13:28.695766+00
1632345586	2	2019-10-08 11:13:31.91879+00
1632345594	1	2019-10-08 11:13:34.590522+00
1632345585	2	2019-10-08 11:13:35.514272+00
1632345583	2	2019-10-08 11:13:41.850098+00
1632345582	2	2019-10-08 11:13:44.352244+00
1632345581	2	2019-10-08 11:13:47.287401+00
1632345580	2	2019-10-08 11:13:51.945618+00
1632345594	2	2019-10-08 11:13:54.284037+00
1632345579	2	2019-10-08 11:13:54.522739+00
1632345578	2	2019-10-08 11:13:58.129243+00
1632345577	2	2019-10-08 11:14:03.961098+00
1632345595	1	2019-10-08 11:14:06.439905+00
1632345596	1	2019-10-08 11:14:24.60161+00
1632345595	2	2019-10-08 11:14:33.380692+00
1632345596	2	2019-10-08 11:14:39.302921+00
1632345597	1	2019-10-08 11:15:33.992539+00
1632345597	4	2019-10-08 11:15:54.994233+00
1632345598	1	2019-10-08 11:16:01.921889+00
1632345599	1	2019-10-08 11:16:20.861993+00
1632345600	1	2019-10-08 11:16:27.067879+00
1632345599	2	2019-10-08 11:16:43.608231+00
1632345601	1	2019-10-08 11:17:02.271447+00
1632345602	1	2019-10-08 11:17:21.671375+00
1632345602	2	2019-10-08 11:17:46.5199+00
1632345603	1	2019-10-08 11:17:50.541266+00
1632345604	1	2019-10-08 11:18:16.372794+00
1632345605	1	2019-10-08 11:18:23.894926+00
1632345604	2	2019-10-08 11:18:40.224164+00
1632345603	2	2019-10-08 11:19:08.296171+00
1632345605	2	2019-10-08 11:19:26.578224+00
1632345604	4	2019-10-08 11:20:40.756298+00
1632345601	2	2019-10-08 11:20:41.962333+00
1632345598	2	2019-10-08 11:20:55.645461+00
1632345600	2	2019-10-08 11:21:01.314427+00
1632345290	2	2019-10-08 11:47:35.48273+00
1632345292	2	2019-10-08 11:47:48.801182+00
1632345294	2	2019-10-08 11:48:18.047461+00
1632345295	2	2019-10-08 11:48:18.054406+00
1632345606	1	2019-10-08 15:03:12.437158+00
1632345606	2	2019-10-08 15:04:30.502395+00
1632345607	1	2019-10-08 15:10:03.316719+00
1632345607	2	2019-10-08 15:12:04.150771+00
1632345608	1	2019-10-08 15:39:24.876778+00
1632345608	2	2019-10-08 15:39:58.98784+00
1632345609	1	2019-10-08 15:55:33.179295+00
1632345609	2	2019-10-08 16:00:00.864185+00
1632345610	1	2019-10-09 13:58:47.181137+00
1632345610	2	2019-10-09 13:59:28.303189+00
1632345611	1	2019-10-09 14:51:03.041312+00
1632345611	2	2019-10-09 15:04:03.615258+00
1632345612	1	2019-10-10 10:05:06.990715+00
1632345612	2	2019-10-10 10:08:08.60394+00
1632345613	1	2019-10-10 10:46:06.316849+00
1632345614	1	2019-10-10 12:03:36.559397+00
1632345614	2	2019-10-10 12:05:09.372278+00
1632345615	1	2019-10-10 12:33:08.427423+00
1632345615	2	2019-10-10 12:33:45.812456+00
1632345616	1	2019-10-10 12:55:13.100442+00
1632345616	2	2019-10-10 12:56:28.425507+00
1632345617	1	2019-10-10 13:04:56.919733+00
1632345617	2	2019-10-10 13:05:28.687821+00
1632345618	1	2019-10-10 23:15:15.626107+00
1632345613	2	2019-10-15 09:40:41.634028+00
1632345618	2	2019-10-15 09:50:18.076764+00
1632345619	1	2019-10-15 11:29:13.214812+00
1632345619	2	2019-10-15 12:30:07.18147+00
1632345620	1	2019-10-15 15:16:33.868654+00
1632345620	2	2019-10-15 15:16:44.954434+00
1632345621	1	2019-10-16 14:49:58.701081+00
1632345621	2	2019-10-16 14:50:23.180858+00
1632345621	4	2019-10-16 14:50:27.33382+00
1632345622	1	2019-10-16 14:56:03.543163+00
1632345622	2	2019-10-16 14:56:25.604866+00
1632345623	1	2019-10-17 09:02:09.02832+00
1632345623	4	2019-10-17 09:02:50.914256+00
1632345624	1	2019-10-17 09:03:32.119773+00
1632345624	2	2019-10-17 09:03:55.704515+00
1632345625	1	2019-10-17 16:52:40.879881+00
1632345625	4	2019-10-17 16:53:42.153067+00
1632345626	1	2019-10-18 11:15:02.416657+00
1632345627	1	2019-10-18 11:15:53.276666+00
1632345628	1	2019-10-18 11:16:56.344875+00
1632345629	1	2019-10-18 11:16:59.440554+00
1632345630	1	2019-10-18 11:17:52.284581+00
1632345631	1	2019-10-18 11:18:03.127276+00
1632345630	2	2019-10-18 11:18:32.768109+00
1632345632	1	2019-10-18 11:19:01.77103+00
1632345631	2	2019-10-18 11:19:14.817878+00
1632345632	2	2019-10-18 11:19:19.948792+00
1632345628	2	2019-10-18 11:19:28.111503+00
1632345633	1	2019-10-18 11:19:40.971752+00
1632345627	2	2019-10-18 11:19:41.682042+00
1632345626	2	2019-10-18 11:19:45.124389+00
1632345634	1	2019-10-18 11:21:05.874101+00
1632345635	1	2019-10-18 11:21:19.219845+00
1632345634	2	2019-10-18 11:21:27.950215+00
1632345636	1	2019-10-18 11:21:56.287658+00
1632345637	1	2019-10-18 11:22:25.745844+00
1632345636	2	2019-10-18 11:22:56.618126+00
1632345638	1	2019-10-18 11:23:13.173411+00
1632345638	2	2019-10-18 11:23:26.532565+00
1632345639	1	2019-10-18 11:23:54.856525+00
1632345640	1	2019-10-18 11:24:18.076825+00
1632345629	2	2019-10-18 11:24:33.851672+00
1632345633	2	2019-10-18 11:24:49.38188+00
1632345640	2	2019-10-18 11:25:09.77298+00
1632345641	1	2019-10-18 11:25:10.465693+00
1632345635	2	2019-10-18 11:25:15.662681+00
1632345641	2	2019-10-18 11:25:29.304076+00
1632345637	2	2019-10-18 11:25:37.075091+00
1632345639	2	2019-10-18 11:25:51.398148+00
1632345642	1	2019-10-18 11:26:01.149574+00
1632345642	2	2019-10-18 11:26:11.598878+00
1632345643	1	2019-10-18 11:26:34.845882+00
1632345643	2	2019-10-18 11:27:07.871452+00
1632345644	1	2019-10-18 11:28:18.510805+00
1632345645	1	2019-10-18 11:29:27.668885+00
1632345645	2	2019-10-18 11:33:10.052996+00
1632345644	2	2019-10-18 11:33:19.009066+00
1632345646	1	2019-10-18 11:40:38.046635+00
1632345646	2	2019-10-18 11:41:20.07718+00
1632345647	1	2019-10-18 11:50:40.487348+00
1632345648	1	2019-10-18 11:51:22.647599+00
1632345649	1	2019-10-18 11:51:41.50022+00
1632345650	1	2019-10-18 11:51:49.696042+00
1632345651	1	2019-10-18 11:51:56.97989+00
1632345652	1	2019-10-18 11:52:16.075855+00
1632345653	1	2019-10-18 11:52:17.649183+00
1632345653	2	2019-10-18 11:52:26.674247+00
1632345654	1	2019-10-18 11:52:36.996212+00
1632345652	2	2019-10-18 11:52:39.605332+00
1632345651	2	2019-10-18 11:52:55.706802+00
1632345650	2	2019-10-18 11:53:01.017713+00
1632345649	2	2019-10-18 11:53:05.780423+00
1632345655	1	2019-10-18 11:53:08.639495+00
1632345647	2	2019-10-18 11:53:11.513359+00
1632345648	2	2019-10-18 11:53:22.188084+00
1632345655	2	2019-10-18 11:53:27.875798+00
1632345656	1	2019-10-18 11:53:42.3723+00
1632345657	1	2019-10-18 11:54:06.514041+00
1632345657	2	2019-10-18 11:54:28.54466+00
1632345658	1	2019-10-18 11:55:05.65898+00
1632345659	1	2019-10-18 11:55:16.296375+00
1632345660	1	2019-10-18 11:55:23.529561+00
1632345659	2	2019-10-18 11:55:29.83979+00
1632345661	1	2019-10-18 11:55:38.318847+00
1632345662	1	2019-10-18 11:55:56.854616+00
1632345663	1	2019-10-18 11:56:08.60853+00
1632345664	1	2019-10-18 11:56:11.112026+00
1632345665	1	2019-10-18 11:56:29.842245+00
1632345660	2	2019-10-18 11:56:49.364517+00
1632345666	1	2019-10-18 11:56:51.336841+00
1632345661	2	2019-10-18 11:56:55.200832+00
1632345662	2	2019-10-18 11:57:05.42018+00
1632345664	2	2019-10-18 11:57:11.397963+00
1632345665	2	2019-10-18 11:57:18.276911+00
1632345666	2	2019-10-18 11:57:22.469234+00
1632345667	1	2019-10-18 11:57:35.75182+00
1632345658	2	2019-10-18 11:57:44.704916+00
1632345656	2	2019-10-18 11:57:52.958855+00
1632345663	2	2019-10-18 11:57:54.15439+00
1632345667	4	2019-10-18 11:58:03.380703+00
1632345668	1	2019-10-18 11:59:32.908479+00
1632345668	2	2019-10-18 11:59:48.705845+00
1632345669	1	2019-10-18 12:01:16.693242+00
1632345669	2	2019-10-18 12:01:26.788521+00
1632345670	1	2019-10-18 12:02:05.440864+00
1632345670	2	2019-10-18 12:02:25.364385+00
1632345671	1	2019-10-18 12:02:51.168024+00
1632345671	2	2019-10-18 12:03:11.931204+00
1632345672	1	2019-10-18 12:03:47.506878+00
1632345672	2	2019-10-18 12:04:12.064053+00
1632345673	1	2019-10-18 12:04:37.358182+00
1632345673	2	2019-10-18 12:04:54.954786+00
1632345674	1	2019-10-18 12:05:27.988606+00
1632345674	2	2019-10-18 12:05:50.387389+00
1632345674	4	2019-10-18 12:06:21.714268+00
1632345675	1	2019-10-18 12:07:15.013335+00
1632345676	1	2019-10-18 12:08:35.988764+00
1632345677	1	2019-10-18 12:09:43.261971+00
1632345678	1	2019-10-18 12:10:36.639572+00
1632345679	1	2019-10-18 12:11:40.150931+00
1632345679	2	2019-10-18 12:12:01.181226+00
1632345678	2	2019-10-18 12:12:13.778367+00
1632345677	2	2019-10-18 12:12:26.298212+00
1632345676	2	2019-10-18 12:12:36.847682+00
1632345675	2	2019-10-18 12:12:48.179258+00
1632345654	4	2019-10-18 12:13:12.941307+00
1632345680	1	2019-10-18 13:39:59.975362+00
1632345680	2	2019-10-18 16:44:33.854914+00
1632345681	1	2019-10-22 11:17:13.715853+00
1632345681	2	2019-10-22 11:30:28.985972+00
1632345682	1	2019-10-22 13:20:04.143596+00
1632345682	2	2019-10-22 13:21:54.392338+00
1632345683	1	2019-11-03 12:39:14.087294+00
1632345683	4	2019-11-04 08:59:25.252623+00
1632345684	1	2019-11-04 16:29:51.207055+00
1632345684	2	2019-11-04 16:30:00.244456+00
1632345685	1	2019-11-05 09:27:49.388225+00
1632345686	1	2019-11-05 09:28:50.843237+00
1632345687	1	2019-11-05 10:05:25.768052+00
1632345687	2	2019-11-05 10:12:10.211048+00
1632345685	2	2019-11-05 10:35:11.245142+00
1632345686	2	2019-11-05 10:35:11.298542+00
1632345688	1	2019-11-05 12:16:50.310604+00
1632345689	1	2019-11-05 12:18:26.953922+00
1632345690	1	2019-11-05 12:26:15.581829+00
1632345691	1	2019-11-05 12:30:58.302925+00
1632345692	1	2019-11-05 14:06:27.861513+00
1632345693	1	2019-11-05 14:09:19.267912+00
1632345694	1	2019-11-05 14:12:20.09047+00
1632345695	1	2019-11-05 14:14:16.931453+00
1632345696	1	2019-11-05 14:18:26.936071+00
1632345697	1	2019-11-05 14:19:26.611917+00
1632345698	1	2019-11-05 14:21:12.514955+00
1632345699	1	2019-11-05 14:22:21.591332+00
1632345700	1	2019-11-05 14:23:41.271361+00
1632345701	1	2019-11-05 14:25:16.439557+00
1632345702	1	2019-11-05 14:26:50.073165+00
1632345703	1	2019-11-05 14:27:50.396447+00
1632345704	1	2019-11-05 14:28:04.03982+00
1632345705	1	2019-11-05 14:30:35.203419+00
1632345706	1	2019-11-05 14:30:39.060642+00
1632345707	1	2019-11-05 14:32:46.504278+00
1632345708	1	2019-11-05 14:35:07.112678+00
1632345709	1	2019-11-05 14:35:33.546687+00
1632345710	1	2019-11-05 14:39:01.380206+00
1632345711	1	2019-11-05 14:39:29.184126+00
1632345712	1	2019-11-05 14:41:10.561624+00
1632345713	1	2019-11-05 14:42:09.859784+00
1632345714	1	2019-11-05 14:44:14.409572+00
1632345715	1	2019-11-05 14:57:17.94942+00
1632345716	1	2019-11-05 14:58:25.781506+00
1632345717	1	2019-11-05 14:59:27.682906+00
1632345718	1	2019-11-05 15:00:25.752358+00
1632345719	1	2019-11-05 15:07:19.114197+00
1632345720	1	2019-11-05 15:08:40.847781+00
1632345721	1	2019-11-05 15:10:09.708155+00
1632345722	1	2019-11-05 15:11:56.966566+00
1632345723	1	2019-11-05 15:13:32.588378+00
1632345724	1	2019-11-05 15:13:51.879587+00
1632345725	1	2019-11-05 15:15:38.863606+00
1632345726	1	2019-11-05 15:17:48.155016+00
1632345727	1	2019-11-05 15:18:12.512801+00
1632345728	1	2019-11-05 15:21:35.085302+00
1632345729	1	2019-11-05 15:23:08.989571+00
1632345730	1	2019-11-05 15:29:01.656124+00
1632345731	1	2019-11-05 15:30:27.476746+00
1632345732	1	2019-11-05 15:32:17.616745+00
1632345733	1	2019-11-05 15:35:27.607367+00
1632345734	1	2019-11-05 15:36:30.173128+00
1632345735	1	2019-11-05 15:39:56.971841+00
1632345736	1	2019-11-05 15:42:11.795468+00
1632345737	1	2019-11-05 15:46:29.950714+00
1632345738	1	2019-11-05 15:47:56.792487+00
1632345739	1	2019-11-05 15:48:50.731828+00
1632345740	1	2019-11-05 15:50:35.504499+00
1632345741	1	2019-11-05 15:54:22.559152+00
1632345742	1	2019-11-05 15:55:38.76283+00
1632345743	1	2019-11-05 15:55:38.873132+00
1632345744	1	2019-11-05 15:57:09.798177+00
1632345745	1	2019-11-05 15:57:48.990261+00
1632345746	1	2019-11-05 15:58:14.126476+00
1632345747	1	2019-11-05 15:59:46.389683+00
1632345748	1	2019-11-05 16:01:26.290497+00
1632345749	1	2019-11-05 16:05:36.402211+00
1632345750	1	2019-11-05 16:06:14.533368+00
1632345751	1	2019-11-05 16:07:29.959474+00
1632345752	1	2019-11-05 16:10:43.871254+00
1632345753	1	2019-11-05 16:12:19.395212+00
1632345754	1	2019-11-05 16:21:03.976757+00
1632345755	1	2019-11-05 16:22:23.714474+00
1632345756	1	2019-11-05 16:24:11.65594+00
1632345757	1	2019-11-05 16:25:00.448654+00
1632345758	1	2019-11-05 16:26:38.983647+00
1632345759	1	2019-11-05 16:27:23.095271+00
1632345760	1	2019-11-05 17:15:09.242473+00
1632345761	1	2019-11-05 17:22:06.909616+00
1632345762	1	2019-11-05 17:24:50.073349+00
1632345763	1	2019-11-05 17:29:10.75005+00
1632345764	1	2019-11-05 17:33:40.923815+00
1632345765	1	2019-11-06 08:18:27.5113+00
1632345766	1	2019-11-06 08:21:21.427613+00
1632345767	1	2019-11-06 08:22:28.723244+00
1632345768	1	2019-11-06 08:29:25.758254+00
1632345769	1	2019-11-06 08:34:12.95979+00
1632345770	1	2019-11-06 08:35:23.278443+00
1632345770	2	2019-11-06 09:02:59.147122+00
1632345765	2	2019-11-06 11:06:48.482895+00
1632345764	2	2019-11-06 11:07:01.533308+00
1632345753	2	2019-11-06 11:08:14.385409+00
1632345751	2	2019-11-06 11:08:27.521136+00
1632345752	2	2019-11-06 11:09:32.369963+00
1632345769	2	2019-11-06 11:17:27.436864+00
1632345768	2	2019-11-06 11:17:42.945221+00
1632345767	2	2019-11-06 11:18:11.491847+00
1632345766	2	2019-11-06 11:18:21.069236+00
1632345763	2	2019-11-06 11:18:37.7378+00
1632345762	2	2019-11-06 11:18:54.651479+00
1632345761	2	2019-11-06 11:19:17.965805+00
1632345760	2	2019-11-06 11:19:28.514922+00
1632345759	2	2019-11-06 11:19:38.950653+00
1632345758	2	2019-11-06 12:07:51.609477+00
1632345757	2	2019-11-06 12:08:00.994612+00
1632345754	2	2019-11-06 12:08:12.786921+00
1632345756	2	2019-11-06 12:08:18.610376+00
1632345755	2	2019-11-06 12:08:31.845634+00
1632345750	2	2019-11-06 12:08:42.762489+00
1632345749	2	2019-11-06 12:08:47.774788+00
1632345748	2	2019-11-06 12:08:56.76369+00
1632345747	2	2019-11-06 12:09:01.824662+00
1632345746	2	2019-11-06 12:09:08.863959+00
1632345745	2	2019-11-06 12:09:18.0379+00
1632345744	2	2019-11-06 12:09:34.801006+00
1632345743	2	2019-11-06 12:09:50.551468+00
1632345742	2	2019-11-06 12:10:05.773651+00
1632345741	2	2019-11-06 12:10:31.545434+00
1632345727	2	2019-11-06 12:10:52.498939+00
1632345728	2	2019-11-06 12:10:57.486218+00
1632345726	2	2019-11-06 12:11:07.024053+00
1632345725	2	2019-11-06 12:11:16.670123+00
1632345724	2	2019-11-06 12:11:28.792132+00
1632345710	2	2019-11-06 12:11:39.190968+00
1632345711	2	2019-11-06 12:11:44.875892+00
1632345709	2	2019-11-06 12:11:51.250482+00
1632345708	2	2019-11-06 12:11:56.725896+00
1632345707	2	2019-11-06 12:12:03.1816+00
1632345706	2	2019-11-06 12:12:12.492495+00
1632345705	2	2019-11-06 12:12:46.873779+00
1632345691	2	2019-11-06 12:13:15.547867+00
1632345690	2	2019-11-06 12:13:31.935066+00
1632345692	2	2019-11-06 12:13:46.302469+00
1632345689	2	2019-11-06 12:13:56.991661+00
1632345688	2	2019-11-06 12:14:14.63069+00
1632345740	2	2019-11-06 12:59:34.023882+00
1632345739	2	2019-11-06 12:59:44.297545+00
1632345738	2	2019-11-06 12:59:50.455292+00
1632345737	2	2019-11-06 12:59:57.662628+00
1632345736	2	2019-11-06 13:00:06.990472+00
1632345735	2	2019-11-06 13:00:15.699981+00
1632345734	2	2019-11-06 13:00:23.59846+00
1632345733	2	2019-11-06 13:00:31.645568+00
1632345732	2	2019-11-06 13:00:35.795928+00
1632345731	2	2019-11-06 13:00:49.468914+00
1632345730	2	2019-11-06 13:00:54.701155+00
1632345729	2	2019-11-06 13:01:10.677008+00
1632345723	2	2019-11-06 13:01:23.998637+00
1632345722	2	2019-11-06 13:01:31.137369+00
1632345721	2	2019-11-06 13:01:48.903528+00
1632345700	2	2019-11-06 13:02:11.700216+00
1632345701	2	2019-11-06 13:02:26.494921+00
1632345699	2	2019-11-06 13:02:33.981275+00
1632345698	2	2019-11-06 13:02:43.879114+00
1632345697	2	2019-11-06 13:02:49.532071+00
1632345696	2	2019-11-06 13:03:01.829447+00
1632345695	2	2019-11-06 13:03:08.118042+00
1632345702	2	2019-11-06 13:06:00.331698+00
1632345703	2	2019-11-06 13:06:14.580173+00
1632345713	2	2019-11-06 13:06:36.679656+00
1632345714	2	2019-11-06 13:06:40.350892+00
1632345715	2	2019-11-06 13:06:42.934805+00
1632345712	2	2019-11-06 13:06:55.15797+00
1632345704	2	2019-11-06 13:07:17.708774+00
1632345716	2	2019-11-06 13:07:57.58995+00
1632345718	2	2019-11-06 13:08:05.24475+00
1632345717	2	2019-11-06 13:08:11.753113+00
1632345720	2	2019-11-06 13:08:29.850313+00
1632345719	2	2019-11-06 13:08:31.081352+00
1632345694	2	2019-11-06 13:10:09.835331+00
1632345693	2	2019-11-06 13:10:12.832396+00
1632345771	1	2019-11-08 14:25:50.189609+00
1632345771	4	2019-11-08 14:58:08.756435+00
1632345772	1	2019-11-10 22:26:33.66276+00
1632345772	2	2019-11-11 10:04:33.292517+00
1632345773	1	2019-11-11 11:10:54.216409+00
1632345773	2	2019-11-11 11:11:10.400438+00
1632345774	1	2019-11-11 12:13:53.230129+00
1632345775	1	2019-11-11 12:18:09.777833+00
1632345776	1	2019-11-11 12:20:30.17806+00
1632345777	1	2019-11-11 15:33:53.110325+00
1632345777	2	2019-11-11 15:34:05.711214+00
1632345777	4	2019-11-11 15:34:32.842495+00
1632345776	2	2019-11-12 15:42:02.600523+00
1632345775	4	2019-11-12 16:16:00.787058+00
1632345774	2	2019-11-12 16:16:24.980045+00
1632345778	1	2019-11-13 10:27:30.762694+00
1632345778	2	2019-11-13 10:29:00.355682+00
1632345779	1	2019-11-18 10:14:41.900005+00
1632345779	2	2019-11-18 10:16:56.911485+00
1632345780	1	2019-11-18 14:14:34.848098+00
1632345780	2	2019-11-18 14:15:04.162321+00
1632345781	1	2019-11-18 14:36:58.359003+00
1632345781	2	2019-11-18 14:44:09.642181+00
1632345782	1	2019-11-18 15:26:22.397963+00
1632345782	2	2019-11-18 15:27:22.244805+00
1632345783	1	2019-11-20 09:11:52.274392+00
1632345783	2	2019-11-20 09:12:33.544032+00
1632345784	1	2019-11-22 08:30:56.969184+00
\.


--
-- TOC entry 3115 (class 0 OID 18216)
-- Dependencies: 212
-- Data for Name: payment_options; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.payment_options (payment_option_id, name, description) FROM stdin;
1	Paiement au ramassage	Le client paye les frais de livraison au moment de la collecte du colis par le coursier
2	Paiement à la livraison	Le destinataire de colis paye les frais de livraison à la livraison du colis
\.


--
-- TOC entry 3123 (class 0 OID 18274)
-- Dependencies: 223
-- Data for Name: positions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.positions (position_id, name, description) FROM stdin;
1	Manager de commandes en ligne	Personne chargée de la gestion de nouvelle commande en ligne, de leur assignation aux agences chargées de la collecte et de la livraison
2	Responsable d'agence	Personne chargée de la gestion de la collecte et de la livraison des colis dans les communes sous la responsabilité de son agence
3	Coursier	Personne chargée de la collecte et de la livraison des colis directement après des clients
\.


--
-- TOC entry 3116 (class 0 OID 18222)
-- Dependencies: 213
-- Data for Name: shipment_categories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.shipment_categories (shipment_category_id, name, min_cost, max_cost) FROM stdin;
1	Documents	1000	2000
2	Colis	1000	2300
\.


--
-- TOC entry 3118 (class 0 OID 18241)
-- Dependencies: 216
-- Data for Name: shipment_states; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.shipment_states (shipment_state_id, name, code, description) FROM stdin;
1	En attente de ramassage	\N	\N
2	Ramassé	\N	\N
3	Échec de ramassage	\N	\N
4	Arrivé à l'agence locale de distribution	\N	\N
5	Depart de l'agence locale de distribution	\N	\N
6	Livré	\N	\N
7	Échec de livraison	\N	\N
8	Retourné	\N	\N
9	Échec d'acheminement	\N	\N
\.


--
-- TOC entry 3117 (class 0 OID 18228)
-- Dependencies: 214
-- Data for Name: shipments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.shipments (shipment_id, order_id, user_id, sender_name, sender_phone, sender_area_id, sender_address, recipient_name, recipient_phone, recipient_area_id, recipient_address, time_created, time_delivered, shipment_category_id, cost, nature, weight, payment_option_id, distance, shipment_state_id, current_office_id) FROM stdin;
1923452359	1632345255	57	KOUAME BEHOUBA 	45001685	64	carrefour abinadair 	Jean Thierry Koffi 	65325821	87	Moscou rue lenine	2019-09-02 11:39:27.326309	\N	1	1250	diplôme du bac	1.5	2	14.819	5	\N
1923452385	1632345288	58	Aie aer	04992398	21	Liberté rue 1	Hein heu sien	08596512	8	Abobo Abobo 	2019-09-19 09:10:18.265433	\N	2	1300	Sac et écharpes	2.1	1	15.106	5	\N
1923452371	1632345279	58	Mi Chou	05014068	114	Bingerville, cité Késsé	Chou babe	01023548	115	Anyama carrefour IVOSEP	2019-09-06 11:19:25.094759	\N	2	1800	Chaussures et sacs	6.3	2	36.216	6	\N
1923452376	1632345276	57	Charles N'dri 	65976495	8	Gare de bassam	Nelson Ali 	65895635	89	Alabama 	2019-09-06 12:12:39.929698	\N	1	1350	Documents administratifs	3	1	19.855	6	\N
1923452369	1632345269	1	Ami Chia	22556010	95	gare marche	Sewa Wa	22503482	105	Port bouet phare	2019-09-04 18:10:49.593405	\N	2	1000	chaussures	9	2	5.905	6	\N
1923452370	1632345278	58	Fat Tou	57164412	65	Cité des arts, Boulevard Françcois-Mitterand Nobert, Cité Lauriers, Villa 49	Iri Na	04333319	49	cocody chateau 	2019-09-06 11:15:54.403936	\N	1	1250	Documents	5	1	12.969	6	\N
1923452361	1632345262	58	Ai Cha	58759855	28	jbvcdsjklpokjdcsnmx	Ma Riam	02545856	95	rdtfgyh7ujkolpèlkbhj	2019-09-04 12:10:20.778755	\N	2	1300	Chaussures et sacs	2	1	13.962	5	\N
1923452360	1632345261	1	kouame behouba manasse	22 52 25 22	37	angre rue princesss	jean didier	22 52 25 22	5	marcory dokui	2019-09-04 12:10:01.387482	\N	2	1150	colis de vetements	9	1	8.657	6	\N
1923452379	1632345282	58	fuukoij	04567900	3	t67ioojhv	étuves kk	09885543	72	Zhou gk7gl	2019-09-10 12:15:08.995375	\N	1	1300	vêtements	0.4	1	16.719	6	\N
1923452366	1632345266	58	Bec Ky	09528997	66	Plateau, Avenue Longchamps	Ja Mi	79797875	115	Anyama carrefour IVOSEP	2019-09-04 12:53:30.928396	\N	1	1450	Documents administratifs	2	1	23.338	6	\N
1923452367	1632345267	58	Ro Ki	84333919	23	mosquée sitarail	Pa Pa	49902912	21	liberté centre nord	2019-09-04 17:43:59.819023	\N	1	1000	sac	6.6	1	1.22	6	\N
1923452365	1632345266	58	Bec Ky	09528997	66	Plateau, Avenue Longchamps	Ja Mi	79797875	115	Anyama carrefour IVOSEP	2019-09-04 12:53:19.519949	\N	1	1450	Documents administratifs	2	1	23.338	6	\N
1923452373	1632345273	57	Yves Roger 	44689525	75	Banco	jean claude	99352154	114	rue des archanges	2019-09-06 12:00:56.85418	\N	1	1500	documents et factures	12	2	27.234	6	\N
1923452380	1632345283	58	Soro	04333919	21	Liberté CIE	Aicha	09531797	66	Plateau avenue Noguès	2019-09-10 12:15:14.527305	\N	1	1000	Documents entreprises	0.5	1	3.504	6	\N
1923452364	1632345265	58	Chou Mie	59990049	29	Agban arrêt 14	Ira You	04333319	59	Aghien mosquée	2019-09-04 12:42:21.656167	\N	2	1000	Cartons de fripperies	3.5	1	6.218	6	\N
1923452363	1632345264	58	Jean Michel	06132315	95	krfgbnmkc,m njbdb	Gildas Koue	09539997	21	kjhgvsmnbftgyui	2019-09-04 12:19:51.457204	\N	1	1250	Documents	5	1	14.195	6	\N
1923452377	1632345275	57	Jean louis 	64563587	115	Anyama 	Moris beats	45631567	66	Rue des banques	2019-09-06 12:14:35.124328	\N	1	1450	Factures	2	2	24.464	6	\N
1923452368	1632345268	1	htfvgg	22522522	1	gare marche	jugewu9oh	22522522	98	koumassi nord	2019-09-04 18:07:17.116266	\N	2	1500	chaussures	8	1	23.253	6	\N
1923452374	1632345277	57	Meïté clovis	64598578	54	Blockhauss	Éric zemour	46325879	20	Adjame 	2019-09-06 12:06:31.469648	\N	1	1150	Fournitures de bureau 	3	1	8.047	6	\N
1923452362	1632345263	58	Chou Mie	59990049	21	adjuaiokkjhdnsm	Ira You	59020105	98	krufioprofihj	2019-09-04 12:15:23.512481	\N	1	1250	Documents	5	1	14.071	6	\N
1923452384	1632345287	1	Soualio Ouatt	02661812	3	Samaké, gare	Zerbo Oumar	56124897	102	bietry dica	2019-09-10 12:18:42.544191	\N	2	1550	anti choc	0.1	2	23.923	5	\N
1923452372	1632345280	58	Ma Pa	75823146	115	gare taxi	Auré Lia	03642589	91	Carrefour CHU	2019-09-06 11:22:34.473883	\N	1	1500	Documents	3	1	25.408	6	\N
1923452375	1632345274	57	Brice David 	22653245	99	Anoumabo	Binger Louis 	45785258	112	Port bouet 	2019-09-06 12:10:32.899788	\N	2	1550	chaussures	6	1	25.743	6	\N
1923452378	1632345281	1	Jessi Ca	01759700	66	Plateau, Rue des banques	Awa Bah	04961605	114	Bingerville, lycée garçons	2019-09-06 12:40:08.39932	\N	1	1400	Doucuments de bureau	7	1	21.383	6	\N
1923452382	1632345285	58	Sekou	04338812	85	Sable, derrière la gare	Ira You	04099753	114	Lycée Mamie fêtai 	2019-09-10 12:15:25.266304	\N	2	1550	Ordinateur portable	2	2	24.837	6	\N
1923452383	1632345286	58	Aicha Soro	02661812	115	Anyama, rue balsic	Behou Ba	87452365	66	Rue du commerce	2019-09-10 12:15:28.837815	\N	1	1450	Documents administratifs	0.2	1	24.464	6	\N
1923452386	1632345289	58	kouassi	59990049	47	rue 12, villa 13	soro	01475826	72	derriere sodeci	2019-09-19 09:19:01.498111	\N	1	1400	documents administratifs	5	1	22.108	6	\N
1923452381	1632345284	58	Mana Dja	06587295	87	Trechiville, pharmacie	Dia Blo	85642189	99	Anoumabo, fabrique	2019-09-10 12:15:21.504947	\N	2	1150	Sacs	6.3	1	7.814	6	\N
1923452393	1632345303	58	Ai 	21545631	66	VGabakansbvs	Cha	05679824	115	Nuabsalaisahs	2019-09-20 10:21:03.221235	\N	1	1450	Documents administratifs 	8	1	23.338	5	\N
1923452394	1632345304	58	Mie	66548721	104	VhUjakajsbsh	Chou	51224488	87	Bajajansjsb	2019-09-20 10:23:25.567997	\N	2	1200	Sacs	2	2	8.943	5	\N
1923452388	1632345301	58	kouassi 	07507384	2	rue	kouao	42790375	19	marché 	2019-09-20 10:16:03.062836	\N	1	1200	chaussures 	8	2	11.033	5	\N
1923452387	1632345302	58	kouassi	07507384	86	église ADCi	yvette	46620546	48	mosquée 	2019-09-20 10:15:23.785432	\N	1	1450	tee sh	5	1	23.742	5	\N
1923452390	1632345299	1	kouassi	07507384	87	rue 2 	sako	46620546	53	rue ministre	2019-09-20 10:16:52.222186	\N	2	1200	vétement	8.5	2	9.07	5	\N
1923452397	1632345307	58	Blaise	08562485	82	Bjshjssjb	Pascal	08965214	8	Ganiashshshsb	2019-09-20 11:11:59.572322	\N	1	1450	Documents administratifs 	7	1	23.219	6	\N
1923452398	1632345308	58	Ira	06524897	21	Bahjaansbsb	You	57461320	105	Naisksnsj	2019-09-20 11:17:42.656596	\N	2	1300	Sac	5	1	14.204	6	\N
1923452395	1632345305	58	Cedric	08597541	65	Haajsbvssb	Jean	59875421	39	Habsksksnsb	2019-09-20 10:25:06.580469	\N	1	1150	Extrait de naissance 	8	1	9.094	6	\N
1923452396	1632345306	58	Soro	58642483	98	Bhahsnsjns	Aicha	08575236	95	Bahnssnkaka	2019-09-20 11:08:26.938589	\N	2	1000	Chaussures 	2	1	1.67	6	\N
1923452391	1632345299	1	kouassi	07507384	87	rue 2 	sako	46620546	53	rue ministre	2019-09-20 10:17:07.339642	\N	2	1200	vétement	8.1	2	9.07	5	\N
1923452392	1632345298	1	ASSIE	57715955	20	BORRY	KOFFI	08416609	45	GOLEF	2019-09-20 10:17:57.276023	\N	2	1350	POLO	12	2	15.279	5	\N
1923452389	1632345300	58	kouassi 	07507384	3	près boulangerie 	Amede	46620546	50	arrêt de bus	2019-09-20 10:16:28.177333	\N	2	1450	chaussures 	5	2	19.569	5	\N
1923452401	1632345316	58	kouassi	07507384	37	rue	soro	46620546	114	rue	2019-09-20 11:56:56.895846	\N	1	1350	chaussures 	7	1	19.392	6	\N
1923452403	1632345314	58	Assie	48561803	66	Plateau 	Koffi	57715955	66	Plateau 	2019-09-20 11:57:25.450527	\N	2	1000	Chapeau 	7	1	0	5	\N
1923452399	1632345309	58	Chou	98563128	22	Hiansbsjoa	Mie	08524897	70	Balisevsve	2019-09-20 11:21:10.963664	\N	2	1500	Portable	2	1	22.419	6	\N
1923452400	1632345310	58	Brandy	05431512	28	JzhHajsbv	Cute 	57246434	66	Bajajahssh	2019-09-20 11:24:25.80145	\N	1	1150	Documents bureau 	1	1	7.591	6	\N
1923452422	1632345326	1	ASSIE 	57715955	20	BORRY	NICKA	59061324	76	QTE	2019-09-23 09:06:36.312687	\N	2	1300	ROBE	2	1	13.109	6	\N
1923452435	1632345338	58	Stsvsie	08563128	28	Rehebeoak	Dajsmskjs	05123694	8	Baissnnh	2019-09-24 12:18:37.409152	\N	2	1200	Chaussures 	6	1	10.659	6	\N
1923452427	1632345327	1	ASSIE YAO ISIDORE	48561803	20	BORRY	GRACE	49096306	48	asd	2019-09-23 11:56:59.974557	\N	2	1300	ordinateur hp	8	1	14.779	5	\N
1923452413	1632345317	1	boni	07145989	1	ABOBO	NEARIA	03246658	8	ABOBO	2019-09-20 12:36:45.341259	\N	1	1000	EXTRAIT	8	1	3.683	6	\N
1923452411	1632345322	1	ASSIE	08416609	23	DALLAS	YAO	57715955	6	ZOO	2019-09-20 12:36:29.344774	\N	2	1200	CHEMISE	2	2	8.837	5	\N
1923452419	1632345323	64	kouassi	07507384	65	rue 21	florence	46620546	61	grand marché	2019-09-20 14:59:23.594861	\N	2	1000	article scolaire	5.7	2	2.37	6	\N
1923452426	1632345328	62	ouattara aissata	57612462	82	yopougon 	MARIAM coulibaly	87610151	21	liberté	2019-09-23 11:48:43.811221	\N	2	1250	micro onde	12	1	10.903	5	\N
1923452428	1632345331	64	kouassi	07507384	65	rue 13	fredy	46620546	46	rue marché	2019-09-23 14:34:41.210134	\N	1	1100	factures	7.5	2	7.032	6	\N
1923452436	1632345339	58	Hzisjsb	08531265	29	Nishsvd	Jajsbvsshau	08523187	65	Jejeowkecehej	2019-09-24 12:21:38.428704	\N	2	1000	Sacs	2	1	6.438	6	\N
1923452420	1632345324	1	assie	48561803	30	BORRY	ANGE	59061314	35	SDE	2019-09-20 16:06:03.990743	\N	2	1000	HP	6	2	4.789	5	\N
1923452431	1632345334	60	franck	07507384	65	rue 12	joce	46620546	105	centre pilote	2019-09-24 11:07:40.391552	\N	2	1400	Chaussures et sacs	5	2	18.457	5	\N
1923452402	1632345315	58	FRANKY	08729981	70	YOP	EMELINE	08729981	72	YOP	2019-09-20 11:57:12.54918	\N	2	1200	CHAUSSUR	6	2	8.919	6	\N
1923452405	1632345313	62	Ouattara	57612462	12	agbekoi	MARIAM	87610151	115	anyama	2019-09-20 11:58:01.138708	\N	2	1200	portable marque iphone	5	2	10.801	6	\N
1923452415	1632345320	1	ouattara	57612462	1	A la gare	danielle	87610151	72	annaneraie	2019-09-20 12:37:25.188857	\N	1	1300	certificat de nationnalite	1	2	16.152	5	\N
1923452417	1632345319	1	bintou	08223240	19	adjame	mariam	55601020	3	abobo	2019-09-20 12:37:44.742604	\N	2	1250	vetments	1	2	12.268	5	\N
1923452404	1632345297	58	emeline	08729981	5	anerai	koffi	08729981	57	soporex	2019-09-20 11:57:41.240459	\N	1	1100	chaussures 	8	2	7.237	5	\N
1923452429	1632345332	58	Assie	48561803	66	Borry	Kouakou	57715955	22	Sable 	2019-09-24 11:07:13.442794	\N	2	1000	Chaussures 	9.5	1	1.594	5	\N
1923452433	1632345336	58	Dhssnskk	08546987	21	Jzjsjsbsb	Jsjshvssb	08526482	95	Jausjasn 	2019-09-24 12:09:54.388809	\N	2	1250	Sac	2	1	11.043	6	\N
1923452434	1632345337	58	Jsbsvssgv	05648208	21	Jvaagaia	Kabahsjasj	59631421	66	Jabahshwnwj	2019-09-24 12:15:11.858095	\N	1	1000	Extrait	2	1	3.504	6	\N
1923452442	1632345343	59	assoukpou	07678980	65	cocody	afoue	22102900	114	bingerville	2019-09-24 14:00:50.471784	\N	2	1450	montre	1	1	20.596	6	\N
1923452440	1632345342	1	kouassi	07507384	76	rue 2	franck	46620546	78	rue 32	2019-09-24 13:58:42.164488	\N	2	1500	chaussure	5.5	1	23.019	6	\N
1923452437	1632345341	60	Konan	87425935	93	Treichville, CHU	KONATE	08170994	102	Marcory, Biétry	2019-09-24 13:58:27.399571	\N	2	1000	Cartons de fripperies	9	2	4.686	6	\N
1923452439	1632345344	62	ACHIMA	40106527	66	st-michel	GOULI	56411473	66	sorbone	2019-09-24 13:58:31.617799	\N	1	1000	extrait	8.5	1	0	6	\N
1923452438	1632345340	58	Traore	49111095	8	Sogefia	Bamba	05872487	115	Mosquée 	2019-09-24 13:58:30.013209	\N	2	1250	Montre 	6	2	11.944	6	\N
1923452414	1632345321	1	jakoua 	48339567	72	YOPOUGON	VAGABA	45776656	98	PLUIE MODIS	2019-09-20 12:37:18.922082	\N	2	1500	CHAUSSUR	2	2	23.498	5	\N
1923452424	1632345329	1	dibgeutine	49494906	11	deux cocotier	digbeu	48484807	32	carrefour adjoua	2019-09-23 11:31:04.142356	\N	2	1400	pagne	5	2	18.911	5	\N
1923452425	1632345329	1	dibgeutine	49494906	11	deux cocotier	digbeu	48484807	32	carrefour adjoua	2019-09-23 11:31:04.145594	\N	2	1400	pagne	1	2	18.911	5	\N
1923452410	1632345312	60	jocelyne	07822971	102	marcory	jonathan	77925469	90	treichville	2019-09-20 11:58:29.66903	\N	1	1000	Documents administratifs	5	1	5.32	5	\N
1923452408	1632345312	60	jocelyne	07822971	102	marcory	jonathan	77925469	90	treichville	2019-09-20 11:58:28.236339	\N	1	1000	Documents administratifs	10	1	5.32	6	\N
1923452430	1632345333	59	OUE	49203638	8	yopougon	DAH	09876543	70	Abidjan, Abidjan	2019-09-24 11:07:30.493603	\N	1	1550	EXTRAIT	12	1	28.065	5	\N
1923452409	1632345312	60	jocelyne	07822971	102	marcory	jonathan	77925469	90	treichville	2019-09-20 11:58:28.969416	\N	1	1000	Documents administratifs	10	1	5.32	6	\N
1923452443	1632345348	1	AICHA	57612462	95	Remblais	Daniel	87610151	101	Zone 4C	2019-09-24 14:08:52.786198	\N	2	1000	Iphone 7	10	2	2.991	6	\N
1923452416	1632345320	1	ouattara	57612462	1	A la gare	danielle	87610151	72	annaneraie	2019-09-20 12:37:31.116848	\N	1	1300	certificat de nationnalite	2	2	16.152	5	\N
1923452432	1632345335	62	KOUASSI	09100683	8	SOGEPHIA	SORO	56411473	65	ANGRE	2019-09-24 11:07:53.257023	\N	1	1200	CASIER JUDICIAIRE	5	2	10.26	5	\N
1923452441	1632345345	59	yao	09876543	2	abobo	marie	08987665	4	abidjan	2019-09-24 14:00:46.017443	\N	1	1150	montre	6	2	8.446	6	\N
1923452421	1632345325	62	aissata	57612462	72	annaneraie	danielle	87610151	102	MACORY	2019-09-20 16:26:36.793693	\N	2	1500	sac a main	8	2	23.601	5	\N
1923452406	1632345293	60	ONAMON raphael	07822971	82	abobo	nina	79708033	21	yopougon	2019-09-20 11:58:09.458784	\N	1	1200	Documents administratifs	10	2	10.903	5	\N
1923452407	1632345311	59	boni	49203638	105	abobo	Valérie Oué	49203638	112	Abidjan, Abidjan	2019-09-20 11:58:13.159169	\N	2	1400	chaussure	4	1	19.394	6	\N
1923452418	1632345318	1	kouassi	07507384	24	rue 23	yobouet	46620546	57	rue 10	2019-09-20 12:39:04.414432	\N	2	1200	une valise	2	2	9.853	5	\N
1923452412	1632345322	1	ASSIE	08416609	23	DALLAS	YAO	57715955	6	ZOO	2019-09-20 12:36:30.942216	\N	2	1200	CHEMISE	3	2	8.837	5	\N
1923452448	1632345349	1	ADOU	08765432	66	sorbonne	line	09345678	66	cite administrative	2019-09-24 14:10:47.289696	\N	2	1000	montre	9	2	0	6	\N
1923452449	1632345349	1	ADOU	08765432	66	sorbonne	line	09345678	66	cite administrative	2019-09-24 14:10:49.898364	\N	2	1000	montre	9	2	0	6	\N
1923452462	1632345365	1	oue	12223455	66	PLATEAU	OUATTARA	57622462	66	PLATEAU	2019-09-25 10:49:48.602025	\N	2	1000	MONTRE	5	1	0	6	\N
1923452450	1632345352	1	kouakou	09275257	65	2 plateaux	kouassi	05872487	37	cocody	2019-09-24 14:36:20.945995	\N	2	1150	colis	2	2	7.103	6	\N
1923452451	1632345351	1	bamba	09275257	66	plateau	kouassi	05872487	66	plateau	2019-09-24 14:36:24.375353	\N	2	1000	colis	8	2	0	6	\N
1923452460	1632345362	1	konan	87425935	87	centre	KONATE	42704758	105	Abattoir	2019-09-25 10:48:49.180649	\N	2	1200	CHAUSSURE	10	1	9.644	5	\N
1923452453	1632345356	62	aissata	57612462	20	djeni kobenan	MARIAM coulibaly	87610151	72	annanéraie	2019-09-24 16:13:29.195532	\N	2	1250	CHAUSSURE	5	1	11.983	5	\N
1923452467	1632345369	1	KONE	87425935	98	LE MICHIGAN	KONATE	42704758	66	PLATEAU	2019-09-25 11:14:07.877084	\N	2	1200	SAC A POUBELLE	10	1	9.217	5	\N
1923452454	1632345357	1	Marie	77802031	88	rue	gisele	01232450	102	rue	2019-09-24 16:27:59.014232	\N	2	1150	vetements	10	1	8.216	6	\N
1923452455	1632345358	64	Janam	07507384	59	galerie santa maria	séphora	46620546	70	église AD	2019-09-25 09:17:59.780751	\N	1	1500	diplome	10	2	26.058	5	\N
1923452444	1632345347	1	marie	22302335	41	ABIDJAN	DOMI	05660707	60	ABIDJAN	2019-09-24 14:08:54.069153	\N	1	1200	EXTRAIT	3	2	11.004	6	\N
1923452461	1632345364	1	sonia	06251948	38	FAYA	DIDIER	40106527	46	FAYA	2019-09-25 10:49:16.780435	\N	2	1000	chaussures	1	2	4.813	6	\N
1923452456	1632345359	64	Arlette	07507384	39	rue 25	Ema	46620546	8	poubelle	2019-09-25 09:26:26.447502	\N	2	1400	habit	9	1	17.544	5	\N
1923452463	1632345366	1	beda	6485786_	1	la gare	konon	85784585	2	anadore	2019-09-25 10:50:55.24303	\N	1	1000	extrait	1	2	2.626	6	\N
1923452447	1632345350	1	bamba	09275257	1	abobo	kouassi	05872487	115	anyama	2019-09-24 14:10:27.912849	\N	1	1200	document	2	2	10.369	6	\N
1923452459	1632345363	64	assoumou	48484809	82	ananerai	ALICE	48484807	21	ANANERAI	2019-09-25 10:48:35.86912	\N	2	1250	habit	8	2	10.903	5	\N
1923452457	1632345360	62	Konan	40106527	8	SOGEPHIA	GOULI	87610151	66	plateau	2019-09-25 10:11:01.599587	\N	2	1400	micro onde	4	1	17.913	5	\N
1923452458	1632345361	1	kouassi	09100683	1	abobo	koffi	40106527	66	st-michel	2019-09-25 10:24:42.0352	\N	1	1300	certificat de nationnalité	6	1	15.453	5	\N
1923452471	1632345374	1	didier	40106527	39	ambassade	sonia	06251948	92	cité du personnel	2019-09-25 11:34:08.483874	\N	2	1250	sac de banane	9	2	11.451	6	\N
1923452474	1632345377	1	DAO	24785676	1	la gare	SOLA	57875640	54	blockhauss	2019-09-25 11:35:33.252886	\N	2	1350	un telephone cellulaire	1	1	16.048	6	\N
1923452464	1632345367	1	KONANA	87425935	95	REMBLAIS	KONATE	87425935	107	GONZAGUEVILLE	2019-09-25 11:02:47.19847	\N	2	1300	IPHONE	10	1	15.185	5	\N
1923452479	1632345382	1	Didier	22222222	94	danga	Didier	22222222	38	Val Doyen 1	2019-09-25 12:51:41.217796	\N	2	1300	montre	8	1	15.088	5	\N
1923452472	1632345375	1	VALRIE	23456789	66	PLATEAU	OPPORTUNE	56676554	115	Anyama	2019-09-25 11:34:36.812479	\N	2	1500	PORTABLE	7	1	23.338	6	\N
1923452473	1632345376	1	GUY	42704758	94	SICOGI	ROGER	87425935	66	PLATEAU	2019-09-25 11:34:51.129659	\N	2	1300	CHAUSSURE	10	2	13.242	6	\N
1923452477	1632345380	1	didier	40106527	42	riviéra 2	konan	56411473	102	biétry	2019-09-25 12:33:01.629954	\N	2	1200	montre	7	1	10.334	5	\N
1923452465	1632345368	1	KONAN	87425935	95	REMBLAIS	KONON	42704758	94	SICOGI	2019-09-25 11:08:25.992734	\N	2	1000	10	10	1	2.102	6	\N
1923452468	1632345371	1	didier	40106527	40	MERMOZ	sonia	06251948	90	ARRAS 3	2019-09-25 11:14:59.201807	\N	1	1150	EXTRAIT DE NAISSANCE	5	1	9.293	6	\N
1923452469	1632345372	1	doumbia	24785674	1	la gare	kouma	57875642	54	blockhauss	2019-09-25 11:15:42.097601	\N	2	1350	un ordinateur	5	2	16.048	6	\N
1923452466	1632345370	1	OUE	23456789	66	PLATEAU	OUATTARA	56676554	115	Anyama	2019-09-25 11:13:37.130427	\N	1	1450	Extrait	5	2	23.338	5	\N
1923452470	1632345373	1	OUE	23456789	66	PLATEAU	OUATTARA	56676554	115	Anyama	2019-09-25 11:21:57.769562	\N	1	1450	Extrait	8	2	23.338	6	\N
1923452475	1632345378	60	Konan	42704758	98	koumassi le Michigan	SORO MARIAM IRAYOU	87452365	102	Bietry	2019-09-25 12:17:26.772164	\N	2	1000	Cartons de fripperies	9	2	3.847	6	\N
1923452478	1632345381	1	bamba	22222222	94	sicogi nord est	barry	88664477	98	Le Michigan	2019-09-25 12:43:42.143582	\N	1	1000	casier judiciaire	8	1	4.149	6	\N
1923452476	1632345379	1	bea	56411473	59	aghien	bile	40106527	93	chu	2019-09-25 12:23:35.250741	\N	1	1250	extrait	5	2	13.651	5	\N
1923452452	1632345355	1	Picherie	02131452	17	rue	choupi	05121011	67	rue	2019-09-24 16:09:09.925948	\N	2	1400	sac a main	4	1	18.921	5	\N
1923452446	1632345350	1	bamba	09275257	1	abobo	kouassi	05872487	115	anyama	2019-09-24 14:10:22.678215	\N	1	1200	document	2	2	10.369	6	\N
1923452423	1632345330	59	sofia	49203638	105	abobo	Valérie Oué	49203638	8	Abidjan, Abidjan	2019-09-23 11:23:47.684104	\N	1	1550	montre	1	2	27.831	5	\N
1923452480	1632345383	1	kouacou	09275257	60	cocody	Ruth	77783408	6	ABOBO	2019-09-25 13:39:26.214684	\N	2	1000	sac à main	2	2	4.25	5	\N
1923452482	1632345385	1	sonia	06251948	39	COCODY	opportune	58597015	45	COCODY	2019-09-25 14:47:10.085727	\N	2	1250	SAC A MAIN	1	1	12.947	6	\N
1923452483	1632345387	59	kouassi	09778341	21	macaci	RUTH	09254325	28	adjamé	2019-09-25 14:47:36.286729	\N	2	1000	montre	2	2	2.056	6	\N
1923452481	1632345384	1	Die	22341250	95	Remblais	Yann	08534567	98	Le Michigan	2019-09-25 14:46:25.50957	\N	2	1000	Montre	9	2	1.67	6	\N
1923452487	1632345390	59	BRICE	23457654	21	ADJAME	OTHNIEL	21341234	65	COCODY	2019-09-25 15:05:16.908294	\N	2	1200	chaussure	2	2	9.089	6	\N
1923452485	1632345389	1	judith	97888900	38	COCODY	ANNE	85868756	94	KOUMASSI	2019-09-25 15:03:22.412213	\N	2	1300	BARRE	4	1	13.49	6	\N
1923452486	1632345388	1	Die	20142014	95	Remblais	bobodiouf	20192019	25	Sodeci	2019-09-25 15:04:34.931773	\N	2	1350	CHAUSSURE	10	2	15.785	6	\N
1923452445	1632345346	1	kouassi	07507384	76	rue 2	franck	46620546	78	rue 32	2019-09-24 14:10:21.679962	\N	2	1500	chaussure	2	1	23.019	6	\N
1923452484	1632345386	64	joce	07822971	105	abattoir	jonathan	77928040	113	aeroport	2019-09-25 14:47:50.689018	\N	1	1150	extrait	5	2	8.544	6	\N
1923452488	1632345393	59	KAR	98876709	65	SAINT JEAN	LOI	67754334	98	Abidjan, Abidjan	2019-09-25 15:19:14.554613	\N	1	1300	EXTRAIT	6	1	15.675	5	\N
1923452496	1632345400	59	ASSIE	57715955	65	2plateau	YAO	48561803	82	Abidjan, Abidjan	2019-09-25 15:50:23.966214	\N	2	1450	chaussure	5	2	21.635	6	\N
1923452498	1632345402	64	joce	07822971	82	abobo doume	falonne	45256521	65	2plateaux	2019-09-25 15:56:28.488877	\N	2	1450	vetements	5	2	19.91	6	\N
1923452503	1632345406	1	JEAN	23456543	3	ABOBO	JUDITH	57890976	91	TREICHVILLE	2019-09-25 16:06:32.082326	\N	1	1300	PATTE	4	1	16.964	6	\N
1923452507	1632345410	1	RUTH	12345432	37	COCODY	BRICE	54321232	100	marcory	2019-09-25 16:06:45.172932	\N	2	1150	portable	1	2	8.564	6	\N
1923452490	1632345394	64	fernande	88701100	82	abobo doume	lea	07822971	65	2plateau	2019-09-25 15:23:18.439053	\N	2	1450	vetements	8	2	19.91	6	\N
1923452491	1632345396	1	DOMI	90987654	4	ABOBO	NéNé	36875849	96	KOUMASSI	2019-09-25 15:23:37.979721	\N	2	1600	TAPIS	4	2	28.165	6	\N
1923452489	1632345391	1	Souké	20192019	94	Sicogi	Siriki	20182018	9	Plaque	2019-09-25 15:21:18.687921	\N	2	1550	Montre	10	2	25.547	6	\N
1923452492	1632345395	1	SOU	87654326	37	YOPOUGON	JAN	56456787	73	ABIDJAN	2019-09-25 15:23:49.590018	\N	1	1300	BAC	6	1	15.756	6	\N
1923452493	1632345395	1	SOU	87654326	37	YOPOUGON	JAN	56456787	73	ABIDJAN	2019-09-25 15:23:51.083957	\N	1	1300	BAC	5	1	15.756	6	\N
1923452513	1632345415	1	KOUMASSI	11111111	94	SICOGI	ABOBO	22222222	6	ZOO	2019-09-25 16:41:16.341348	\N	2	1450	CHAUSSURE	10	1	20.12	6	\N
1923452505	1632345409	64	jona	07822971	72	ananeraie	kouadio	22335420	96	port bouet	2019-09-25 16:06:38.144152	\N	2	1500	vetements	8	2	22.436	6	\N
1923452515	1632345416	1	KOUMASSI	11111111	94	SICOGI	ABOBO	22222222	115	Anyama	2019-09-25 16:41:31.123224	\N	2	1800	CHAUSSURE	10	1	35.644	6	\N
1923452497	1632345401	1	Konan	44444444	96	port-bouet 2	Bamba	00000000	7	Baoulé	2019-09-25 15:51:57.270275	\N	2	1400	brosse	6	2	19.374	5	\N
1923452511	1632345411	64	josiane	22492312	73	rue12	caro	22503116	115	rue20	2019-09-25 16:11:22.661918	\N	1	1400	extrait	2	1	21.341	6	\N
1923452494	1632345397	1	Konan	44444444	96	port-bouet 2	Bamba	00000000	7	Baoulé	2019-09-25 15:47:19.064964	\N	2	1400	brosse	7	2	19.374	6	\N
1923452495	1632345398	1	souké	09998980	1	ABOBO	baba	03232345	98	KOUMASSI	2019-09-25 15:47:24.268939	\N	1	1450	TISSU	1	1	23.253	6	\N
1923452510	1632345413	64	mamie	08291225	72	rue22	lea	01133560	65	rue20	2019-09-25 16:11:10.069216	\N	1	1300	article scolaire	3	1	15.088	5	\N
1923452502	1632345404	1	koumassi	22222222	94	SICOGI	Abobo	11111111	18	n'dotré	2019-09-25 16:06:23.310158	\N	1	1700	extrait de naissance	4	1	35.672	6	\N
1923452508	1632345405	1	RUTH	12345432	37	COCODY	BRICE	54321232	115	anyama	2019-09-25 16:07:16.321117	\N	1	1450	extrait	3	2	22.548	6	\N
1923452512	1632345414	1	DIJ	23456543	3	ABOBO	JETLI	57890976	45	COCODY	2019-09-25 16:12:42.700769	\N	1	1450	ATRES	8	1	22.898	6	\N
1923452500	1632345403	1	koumassi	22222222	94	SICOGI	Cocody	11111111	45	Riviera 5	2019-09-25 16:05:30.078468	\N	1	1400	extrait de naissance	2	1	21.731	6	\N
1923452499	1632345399	64	joce	02255690	82	abobo doume	falonne	02221100	65	2plateaux	2019-09-25 16:01:55.350225	\N	2	1450	vetements	8	2	19.91	6	\N
1923452504	1632345407	1	koumassi	22222222	94	SICOGI	yopougon	11111111	75	banco nord	2019-09-25 16:06:34.700089	\N	1	1500	extrait de naissance	6	1	26.719	6	\N
1923452517	1632345418	59	LAR	34567890	57	Abidjan	HOU	34567890	70	Abidjan, Abidjan	2019-09-25 16:44:50.367906	\N	2	1550	montre	6	1	25.76	6	\N
1923452501	1632345408	1	RUTH	12345432	37	COCODY	BRICE	54321232	85	yopougon	2019-09-25 16:06:04.826606	\N	2	1250	montre	2	2	11.268	6	\N
1923452522	1632345424	1	othniel	12324312	39	COCODY	BENEDICTE	49111095	93	TREICHVILLE	2019-09-25 17:07:30.894212	\N	2	1200	MONTRE	5	1	10.52	6	\N
1923452506	1632345409	64	jona	07822971	72	ananeraie	kouadio	22335420	96	port bouet	2019-09-25 16:06:40.931636	\N	2	1500	vetements	2	2	22.436	5	\N
1923452521	1632345425	1	sabine	21221340	68	rue12	ghislain	44231010	95	rue23	2019-09-25 17:04:34.193286	\N	1	1350	extrait	5	1	19.014	6	\N
1923452526	1632345429	1	ARIELLE	22222222	95	12	AUDREY	77777777	94	12	2019-09-26 14:26:29.630488	\N	2	1000	CHAUSSURES	8	2	2.102	6	\N
1923452518	1632345420	1	Marie	21003344	67	rue12	ange	23210040	37	rue2	2019-09-25 16:45:11.488774	\N	2	1300	chaussures	1	1	13.564	6	\N
1923452514	1632345417	1	papitou	09877654	4	ABOBO	VIEUX	78652447	89	TREICHVILLE	2019-09-25 16:41:26.722193	\N	2	1500	GHY	4	1	23.369	6	\N
1923452516	1632345421	1	ADJA	09877654	115	ABOBO	TANIA	78652447	102	MARCORY	2019-09-25 16:44:50.150493	\N	2	1700	GANTS	2	1	32.367	6	\N
1923452519	1632345422	1	adja	88221311	68	rue12	raissa	03122015	39	rue2	2019-09-25 16:47:07.621137	\N	2	1300	chaussures	8	2	13.992	6	\N
1923452525	1632345427	58	rosé 	23371818	48	rue 45	tych	01010101	4	rue des grâces	2019-09-26 14:18:26.232564	\N	1	1500	veste	25	1	27.46	5	\N
1923452520	1632345426	1	drissa	09834456	2	ABOBO	vadoumana	08506670	71	YOPOUGON	2019-09-25 17:02:18.465033	\N	2	1450	TREHIS	5	1	21.536	6	\N
1923452528	1632345431	1	oyo	46620546	69	rue carre	gao	3654565_	9	maquis 225	2019-09-26 14:59:17.848756	\N	2	1650	habit	5.6	2	29.459	5	\N
1923452523	1632345423	1	KOUMASSI	11111111	94	Sicogi nord est	Cocody	22222222	40	Mermoz	2019-09-25 17:12:49.026066	\N	1	1250	fer à beton	10	2	14.84	6	\N
1923452527	1632345430	1	oyo	07777777	71	AD	gao	46620546	9	mosqué	2019-09-26 14:42:00.032056	\N	2	1550	SAC DE VOYAGE	9	1	24.792	5	\N
1923452529	1632345432	58	kk	07507384	1	boulangerie 	mm	04568757	103	espace de jeux	2019-09-26 15:21:26.058839	\N	2	1450	lunettes 	3	2	20.041	5	\N
1923452524	1632345428	1	ARIELLE	22222222	67	12	AUDREY	11111111	90	rue5	2019-09-26 14:17:53.929594	\N	2	1300	PAGNES	3	2	15.167	5	\N
1923452530	1632345433	62	assie	48561803	22	adj	danielle	57715955	66	ABIDJAN	2019-09-26 16:05:56.446052	\N	2	1000	portable marque iphone	3	1	1.719	6	\N
1923452531	1632345434	1	ppp	07507384	1	rue2	mmmm	46620546	115	mosquée centrale	2019-09-26 17:18:27.658865	\N	1	1200	sac	8	1	10.369	6	\N
1923452534	1632345437	1	marie	11111111	5	RUE21	francine	22222222	8	rue2	2019-09-27 10:55:27.912149	\N	1	1150	documents	6	2	7.697	6	\N
1923452509	1632345412	1	DAH	23456543	3	ABOBO	JAK	57890976	75	YOPOUGON	2019-09-25 16:09:59.676152	\N	1	1300	TRIS	9	1	15.637	5	\N
1923452532	1632345436	59	LAR	34567689	66	Plateau	SOU	87654567	66	RUE34	2019-09-27 10:54:19.281536	\N	2	1000	MECHE	6	2	0	6	\N
1923452535	1632345437	1	marie	11111111	5	RUE21	francine	22222222	8	rue2	2019-09-27 10:55:35.73525	\N	1	1150	documents	2	2	7.697	6	\N
1923452556	1632345458	1	melissa	44444444	6	RUE5	NINA	66666666	64	RUE1	2019-09-27 11:51:22.795676	\N	2	1200	CHAPEAUX	3	1	8.772	6	\N
1923452533	1632345438	1	landry	12321234	94	kouassi	ruth	12098765	90	treichville	2019-09-27 10:55:26.840286	\N	2	1200	montre	5	2	9.337	6	\N
1923452536	1632345435	65	konan	87425935	65	2 plateau	Bamba	11111111	61	ANGRE	2019-09-27 10:56:00.42789	\N	2	1000	sac a main	10	2	2.37	6	\N
1923452544	1632345447	65	Konan	87425935	59	AGHIEN	OUE	11111111	66	plateau	2019-09-27 11:20:17.313683	\N	1	1200	CASIER JUDICIAIRE	4	1	10.695	6	\N
1923452537	1632345439	1	marie	11111111	5	RUE3	FRANCINE	22222222	8	RUE3	2019-09-27 10:58:02.196435	\N	1	1150	DOCUMENTS	4	2	7.697	6	\N
1923452557	1632345460	1	konan	22222222	37	DANGA	PLATEAU	22222222	66	plateau	2019-09-27 11:51:59.075729	\N	2	1000	chaussure	10	1	4.845	6	\N
1923452550	1632345450	65	Konan	87425935	59	Aghien	koumassi	11111111	96	port bouet	2019-09-27 11:30:54.548649	\N	2	1300	CHAUSSURE	10	1	14.396	6	\N
1923452565	1632345467	1	sylvie	77777777	1	RUE7	SYLVIE	99999999	66	RUE5	2019-09-27 11:57:23.96182	\N	2	1350	FOULARD	6	1	15.453	5	\N
1923452554	1632345454	59	MAR	45678909	66	RUE 45	GOU	45678909	8	botoboto	2019-09-27 11:33:27.697592	\N	2	1350	MECHE	5	1	16.715	5	\N
1923452543	1632345445	1	paul	12321234	94	koumassi	jean	98986900	7	abobo	2019-09-27 11:19:49.163519	\N	2	1550	stylo	1	2	24.368	6	\N
1923452563	1632345465	59	HAU	09898767	66	RUE 45	DOU	45678789	8	botoboto	2019-09-27 11:54:28.114213	\N	2	1350	MONTRE	7	1	16.715	5	\N
1923452552	1632345455	1	melissa	44444444	6	RUE5	NINA	66666666	94	RUE1	2019-09-27 11:32:51.760437	\N	2	1350	CHAPEAUX	6	1	16.767	6	\N
1923452539	1632345441	1	landry	92866903	94	koumassi	Opportune	12324312	43	cocody	2019-09-27 11:08:34.563809	\N	2	1350	lit	5	2	17.357	6	\N
1923452538	1632345440	65	konan	87425935	57	Abbri 2000	SORO	11111111	94	Sicogi	2019-09-27 11:08:25.296795	\N	2	1300	micro onde	10	2	13.572	6	\N
1923452546	1632345448	1	VERO	00000000	7	RUE0	ANGE	66666666	40	RUE8	2019-09-27 11:20:45.199961	\N	2	1250	CHEMISES	3	1	12.379	6	\N
1923452545	1632345446	59	LOU	34567689	66	RUE 45	MAR	87654567	98	RUE34	2019-09-27 11:20:37.671788	\N	2	1200	MECHE	4	1	9.236	6	\N
1923452541	1632345443	59	JAR	45678909	66	RUE 45	MAR	45765678	8	botoboto	2019-09-27 11:10:32.843143	\N	1	1300	EXTRAIT	5	1	16.715	6	\N
1923452540	1632345442	1	BLANDINE	77777777	7	RUE9	SYLVIE	66666666	66	RUE5	2019-09-27 11:08:52.055042	\N	2	1400	VETEMENTS	7	2	19.134	6	\N
1923452542	1632345444	68	amenan	08729981	21	portorportor	ZONGO	49494909	28	placali	2019-09-27 11:15:27.476432	\N	2	1000	BROSSE	5	2	2.056	6	\N
1923452548	1632345452	1	melissa	44444444	6	RUE5	RAOUL	66666666	41	RUE1	2019-09-27 11:30:50.899615	\N	2	1250	CHAPEAUX	6	1	11.624	6	\N
1923452566	1632345468	1	CARO	77777777	1	RUE7	RAISSA	99999999	63	RUE5	2019-09-27 12:05:27.66866	\N	2	1250	VESTE	7	1	11.305	6	\N
1923452549	1632345451	1	Othniel	21432157	94	koumassi	Luc	54936959	23	adjamé	2019-09-27 11:30:51.365337	\N	2	1450	montre	4	2	20.8	5	\N
1923452553	1632345456	59	KOU	45678909	66	RUE89	JOU	90098776	98	RUE5	2019-09-27 11:33:18.810049	\N	1	1150	EXTRAIT	8	1	9.236	5	\N
1923452572	1632345470	1	lub	55455655	94	koumassi	lou	23466777	26	adjamé	2019-09-27 12:07:50.027288	\N	1	1350	livre	2	1	19.815	6	\N
1923452569	1632345471	1	NOU	67875654	66	RUE45	GOU	78986775	4	BOTO	2019-09-27 12:06:37.07101	\N	1	1400	EXTRAIT	6	1	20.229	5	\N
1923452547	1632345449	1	Othniel	21432157	94	koumassi	Luc	54936959	66	plateau	2019-09-27 11:30:41.039959	\N	1	1250	livre	1	2	13.242	6	\N
1923452560	1632345462	59	KOU	56789876	66	RUE 45	SOU	56764567	98	RUE34	2019-09-27 11:52:36.692617	\N	2	1200	MECHE	5	1	9.236	6	\N
1923452551	1632345453	65	konan	87425935	65	AGHIEN	adjame	11111111	21	libeté	2019-09-27 11:31:38.002511	\N	2	1150	CHAUSSURE	10	2	8.686	5	\N
1923452559	1632345459	1	luc	13455666	94	koumassi	jean	14667776	66	plateau	2019-09-27 11:52:32.462798	\N	2	1300	montre	1	1	13.242	6	\N
1923452561	1632345463	1	luc	13455666	94	koumassi	jean	14667776	55	cocody	2019-09-27 11:52:45.810484	\N	2	1400	riz	1	2	17.443	6	\N
1923452558	1632345461	65	KONAN	87425935	46	Anono	koumassi	11111111	94	Sicogi	2019-09-27 11:52:13.675564	\N	2	1200	sac a main	10	1	10.296	6	\N
1923452570	1632345474	1	lub	55455655	94	koumassi	luc	23466777	66	plateau	2019-09-27 12:06:45.870583	\N	1	1250	livre	1	1	13.242	6	\N
1923452562	1632345466	1	melissa	44444444	6	RUE5	NINA	66666666	64	RUE1	2019-09-27 11:54:21.672399	\N	2	1200	CHAPEAUX	6	1	8.772	5	\N
1923452555	1632345457	1	kkk	45454567	20	RUE 5	JJJJ	07070707	6	RUE 4	2019-09-27 11:43:57.292407	\N	1	1000	DIPLOME	5	1	6.488	6	\N
1923452571	1632345475	1	OI	09897898	66	RUE98	LOI	09876545	95	BOIM	2019-09-27 12:07:22.716665	\N	2	1200	MONTRE	8	1	8.858	5	\N
1923452564	1632345464	59	HAU	09898767	66	RUE 45	DOU	45678789	8	botoboto	2019-09-27 11:54:36.639634	\N	2	1350	MONTRE	7	1	16.715	6	\N
1923452567	1632345469	1	KONAN	00000000	37	danga	koumassi	00000000	94	sicogi	2019-09-27 12:05:34.10069	\N	2	1250	chaussure	10	1	11.249	6	\N
1923452575	1632345476	1	RAPHAEL	77777777	1	RUE7	RAISSA	99999999	66	RUE5	2019-09-27 12:08:20.945153	\N	2	1350	VESTE	5	1	15.453	6	\N
1923452574	1632345472	1	assie	11111111	20	SZA	ZAE	22222222	5	STR	2019-09-27 12:08:06.442785	\N	2	1000	CHAUSSURE	1	1	4.578	5	\N
1923452576	1632345477	1	assie	11111111	21	SDF	ZAE	22222222	45	STR	2019-09-27 12:10:41.062124	\N	2	1300	CHAUSSURE	1	1	13.931	6	\N
1923452568	1632345473	65	konan	87425935	65	2 plateaux	Adjamé	11111111	21	liberté	2019-09-27 12:06:35.962622	\N	2	1150	CHAUSSURE	10	1	8.686	6	\N
1923452573	1632345472	1	assie	11111111	20	SZA	ZAE	22222222	5	STR	2019-09-27 12:08:02.624738	\N	2	1000	CHAUSSURE	4	1	4.578	6	\N
1923452579	1632345482	1	luv	12345678	94	koumassi	jean	22331545	114	bingerville	2019-09-27 14:12:31.182024	\N	1	1550	livre	1	2	27.574	6	\N
1923452578	1632345480	1	mi	23232323	3	rue 1	chou	00000000	102	rue6	2019-09-27 14:12:23.954609	\N	1	1450	DIPLOME	6	1	23.923	6	\N
1923452581	1632345481	1	MOU	34567898	66	RES	VOU	89875678	90	HUY	2019-09-27 14:12:53.490141	\N	1	1000	EXTRAIT	5	1	4.773	6	\N
1923452583	1632345479	1	luv	12345678	94	koumassi	jean	22331545	66	plateau	2019-09-27 14:13:21.80342	\N	1	1250	livre	1	1	13.242	6	\N
1923452582	1632345484	65	konan	11111111	46	ANONO	konan	11111111	115	anyama	2019-09-27 14:13:01.911729	\N	2	1550	CHAUSSURE	1	1	25.583	6	\N
1923452602	1632345497	1	luc	66666666	94	koumassi	jean	11111111	31	adjamé	2019-09-27 14:41:31.636393	\N	2	1450	lit	1	1	20.654	5	\N
1923452588	1632345485	1	LOU	45678909	66	POI	COU	67565434	45	YUI	2019-09-27 14:14:07.190387	\N	1	1300	EXTRAIT	8	1	15.54	5	\N
1923452590	1632345491	1	mi	23232323	3	rue 1	YOU	00000000	26	rue6	2019-09-27 14:17:29.374538	\N	1	1000	DIPLOME	1	1	6.67	5	\N
1923452598	1632345502	1	luc	66666666	94	koumassi	jean	11111111	64	cocody	2019-09-27 14:41:09.539755	\N	2	1400	lit	1	1	18.165	6	\N
1923452605	1632345508	1	PI	99999999	6	RUE2	wi	99999999	23	rue6	2019-09-27 14:43:01.368902	\N	2	1200	polo	5	1	10.448	6	\N
1923452577	1632345478	1	konan	11111111	37	danga	konan	11111111	100	CENTRE	2019-09-27 14:12:23.813074	\N	2	1150	CHAUSSURE	10	1	8.564	6	\N
1923452586	1632345486	1	assie	57715955	20	DALLAS	SALLA	48561803	5	DOKUI	2019-09-27 14:13:53.979534	\N	2	1000	CHAUSSURE	3	1	4.578	6	\N
1923452591	1632345492	1	konan	11111111	37	danga	konan	11111111	100	LIBERTE	2019-09-27 14:18:29.605771	\N	2	1150	CHAUSSURE	10	1	8.564	5	\N
1923452599	1632345501	1	KOFFI	24252627	20	RU 	ASSIE	23232425	99	RUE 	2019-09-27 14:41:24.123925	\N	2	1300	MONTRE	11	1	15.046	6	\N
1923452617	1632345518	1	Amie	01010101	64	cocody	Mariam	40404040	102	marcory	2019-09-27 15:46:21.141788	\N	1	1300	diplome	5	1	15.06	5	\N
1923452584	1632345487	1	assie	57715955	20	DALLAS	SALLA	48561803	94	DSD	2019-09-27 14:13:44.387324	\N	2	1350	CHAUSSURE	2	1	16.541	6	\N
1923452603	1632345506	1	KOFFI	24252627	20	RU 	ASSIE	23232425	114	RUE 	2019-09-27 14:42:17.280472	\N	2	1450	MONTRE	12	1	21.122	6	\N
1923452580	1632345483	1	luv	12345678	94	koumassi	jean	22331545	15	abobo	2019-09-27 14:12:39.245426	\N	1	1600	livre	1	2	31.438	6	\N
1923452601	1632345497	1	luc	66666666	94	koumassi	jean	11111111	31	adjamé	2019-09-27 14:41:29.067283	\N	2	1450	lit	1	1	20.654	6	\N
1923452589	1632345490	1	assie	57715955	20	DALLAS	SALLA	48561803	114	BN	2019-09-27 14:14:21.597297	\N	2	1450	CHAUSSURE	4	1	21.122	6	\N
1923452587	1632345489	1	mi	23232323	3	rue 1	PI	00000000	26	rue6	2019-09-27 14:14:03.772198	\N	1	1000	DIPLOME	7	1	6.67	6	\N
1923452585	1632345488	1	FOU	89098767	66	POI	JOU	5687787_	25	YUI	2019-09-27 14:13:48.005626	\N	1	1000	EXTRAIT	6	1	4.987	6	\N
1923452592	1632345493	1	konan	11111111	37	DANGA	konan	11111111	25	SODECI	2019-09-27 14:24:43.152533	\N	2	1150	CHAUSSURE	10	1	8.284	6	\N
1923452607	1632345495	1	konan	11111111	37	DANGA	konan	11111111	25	SODECI	2019-09-27 14:43:39.216773	\N	2	1150	CHAUSSURE	10	1	8.284	5	\N
1923452613	1632345513	1	KOI	56767898	66	OIU	JOI	34343467	91	JKO	2019-09-27 14:48:11.14767	\N	1	1000	BAC	6	1	3.622	6	\N
1923452594	1632345500	1	luc	66666666	94	koumassi	jean	11111111	66	plateau	2019-09-27 14:40:58.726143	\N	2	1300	lit	1	1	13.242	6	\N
1923452609	1632345511	1	PI	99999999	6	RUE2	VI	99999999	66	rue6	2019-09-27 14:44:55.200247	\N	2	1250	polo	8	1	11.538	6	\N
1923452604	1632345507	1	konan	11111111	37	DANGA	konan	11111111	25	SODECI	2019-09-27 14:42:45.144767	\N	2	1150	CHAUSSURE	10	1	8.284	5	\N
1923452597	1632345503	1	KOI	56767898	66	OIU	JOI	34343467	21	JKO	2019-09-27 14:41:07.477633	\N	1	1000	BAC	8	1	3.38	5	\N
1923452618	1632345519	1	hi	00000000	1	rue12	ha	55555555	104	rue7	2019-09-27 16:10:48.644814	\N	1	1550	DOSSIERS	7	1	27.823	5	\N
1923452614	1632345515	1	konan	11111111	37	DANGA	konan	11111111	66	PLATEAU	2019-09-27 14:49:20.546352	\N	2	1000	CHAUSSURE	10	1	4.845	5	\N
1923452612	1632345514	1	konan	11111111	37	DANGA	konan	11111111	25	PLATEAU	2019-09-27 14:48:00.168332	\N	2	1150	CHAUSSURE	10	1	8.284	5	\N
1923452600	1632345505	1	KOI	56767898	66	OIU	JOI	34343467	114	JKO	2019-09-27 14:41:24.943218	\N	1	1400	BAC	8	1	21.383	6	\N
1923452610	1632345512	1	PI	99999999	6	RUE2	SI	99999999	64	rue6	2019-09-27 14:46:44.164687	\N	2	1200	polo	5	1	8.772	6	\N
1923452608	1632345510	1	luc	66666666	94	koumassi	jean	11111111	18	abobo	2019-09-27 14:43:52.190163	\N	2	1800	lit	5	1	35.672	5	\N
1923452593	1632345498	1	PI	99999999	6	RUE2	OH	99999999	100	rue6	2019-09-27 14:40:45.141616	\N	2	1300	CHEMISES	8	1	14.521	6	\N
1923452595	1632345499	1	KOI	56767898	66	OIU	JOI	34343467	21	JKO	2019-09-27 14:41:00.891668	\N	1	1000	BAC	5	1	3.38	6	\N
1923452596	1632345504	65	konan	87425935	46	anono	abobo	11111111	7	baoulé	2019-09-27 14:41:04.807101	\N	2	1250	CHAUSSURE	10	1	12.04	6	\N
1923452606	1632345496	1	luc	66666666	94	koumassi	jean	11111111	9	abobo	2019-09-27 14:43:32.709481	\N	2	1650	lit	1	1	29.13	6	\N
1923452623	1632345524	1	koffi	34353637	20	voila sa	VIRUS MODI	23242526	104	MOUGOU PEN	2019-09-27 16:20:31.705897	\N	2	1450	LALA	5	1	20.771	6	\N
1923452611	1632345509	1	KOI	56767898	66	OIU	JOI	34343467	6	JKO	2019-09-27 14:47:18.084728	\N	1	1200	BAC	5	1	11.449	6	\N
1923452615	1632345516	1	luc	22222222	94	koumassi	jean	22535525	45	cocody	2019-09-27 15:06:19.357011	\N	2	1450	lit	8	2	21.731	5	\N
1923452620	1632345521	1	hi	00000000	1	rue12	ha	55555555	104	rue7	2019-09-27 16:13:03.902482	\N	1	1550	DOSSIERS	7	1	27.823	6	\N
1923452619	1632345520	1	luc	45316521	104	abidjan	jean	78154456	7	abobo	2019-09-27 16:12:09.788087	\N	2	1550	lit	2	2	25.311	6	\N
1923452622	1632345523	1	luc	55541212	107	abidjan	jean	25258527	23	adjamé	2019-09-27 16:19:24.933484	\N	2	1650	lit	2	2	28.433	6	\N
1923452621	1632345522	1	luc	52555555	96	abidjan	brice	77855555	26	adjamé	2019-09-27 16:16:51.769236	\N	2	1300	lit	2	2	14.821	5	\N
1923452616	1632345517	1	konan	87425935	95	REMBLAIS	KONE	08524033	41	riviéra 1	2019-09-27 15:26:09.452208	\N	2	1000	CHAUSSURE	1	1	6.219	5	\N
1923452624	1632345525	1	konan	08170894	37	Danga	konaté	12345678	105	ABATTOIR	2019-09-27 16:43:42.259652	\N	2	1300	balle blanche	3	1	13.691	5	\N
1923452625	1632345526	1	konan	08170894	113	Aéroport	konaté	12345678	105	ABATTOIR	2019-09-27 16:46:52.360112	\N	2	1150	balle blanche	5	1	7.285	6	\N
1923452626	1632345527	1	konan	08170894	37	danga	konaté	12345678	40	mermoz	2019-09-27 17:12:22.124393	\N	2	1000	balle blanche	10	1	2.736	6	\N
1923452627	1632345528	1	konan	11111111	1	gare	aissata	57612462	2	anador	2019-09-30 10:24:29.856457	\N	2	1000	chaussure	10	1	2.626	6	\N
1923452628	1632345529	1	konan	89552735	1	gare	konaté	22222222	94	Sicogi	2019-09-30 10:57:56.611557	\N	2	1500	chaussure	10	1	23.593	5	\N
1923452629	1632345529	1	konan	89552735	1	gare	konaté	22222222	94	Sicogi	2019-09-30 10:57:59.875326	\N	2	1500	chaussure	10	1	23.593	6	\N
1923452651	1632345541	1	AS	11161616	20	MOSQUE	AYA	23232456	41	BVD	2019-10-07 14:37:14.044202	\N	2	1250	MANGUES	7	1	11.315	6	\N
1923452643	1632345548	1	AS	11161616	68	MOSQUE	AYA	23232456	115	BVD	2019-10-07 14:36:22.237052	\N	2	1500	VOITURE	3	1	22.436	6	\N
1923452640	1632345537	58	Choumie	45671234	3	jffvyjjhwfg	Manass	79004562	40	vtujgertgf	2019-10-07 13:52:43.908689	\N	1	1250	sac à main	8	1	14.479	6	\N
1923452630	1632345530	1	Paul	32112422	94	KOUMASSI	jean Marc	09876544	9	abobo	2019-09-30 12:02:08.282561	\N	2	1650	sac de riz	2	2	29.13	6	\N
1923452631	1632345530	1	Paul	32112422	94	KOUMASSI	jean Marc	09876544	9	abobo	2019-09-30 12:02:17.010827	\N	2	1650	sac de riz	2	2	29.13	6	\N
1923452650	1632345542	1	danielle	87610151	42	la 2	aissata	57614246	101	zone 4	2019-10-07 14:37:09.449693	\N	2	1150	placali sauce graine	24	2	8.493	6	\N
1923452644	1632345548	1	AS	11161616	68	MOSQUE	AYA	23232456	115	BVD	2019-10-07 14:36:27.047522	\N	2	1500	VOITURE	5	1	22.436	5	\N
1923452639	1632345540	58	Lil Dee	09876543	102	Biétry, zone 4C	Liam Payne	78543213	20	Williamsville, carrefour Mosquée	2019-10-07 13:52:37.073861	\N	1	1300	Chaussures	5	2	16.088	6	\N
1923452632	1632345531	1	konan	87425935	1	Gare	sidiki	01224456	94	sicogi	2019-09-30 12:09:02.574281	\N	2	1500	chaussure	10	1	23.593	6	\N
1923452633	1632345532	1	konan	87425935	1	Gare	sidiki	01224456	102	biétry	2019-09-30 12:09:20.818051	\N	2	1500	chaussure	10	1	23.356	6	\N
1923452634	1632345533	1	luc	02451274	95	78451236	paul	45967812	87	rue12	2019-10-01 14:32:32.244327	\N	2	1000	télépone portable	11	2	6.044	6	\N
1923452635	1632345534	1	siaka 	48414540	20	carrefou ozangar	ouattara aissata	57612462	87	rue 12	2019-10-01 14:43:36.105418	\N	2	1200	bague de demande en mariage	4	1	9.398	6	\N
1923452636	1632345535	1	kouame	22321234	66	plateau	Jean Marc	22213467	66	plateau	2019-10-01 15:42:32.082161	\N	2	1000	ordinateur	1	2	0	6	\N
1923452637	1632345538	58	Vladimir Poutine	03335684	61	Angré, Djibi	Zaguirov Roustame	04213587	91	Treichville, Biafra, rue 12	2019-10-05 13:39:18.480661	\N	2	1250	Paquets de stylos et crayons	3.6	1	12.756	6	\N
1923452638	1632345539	58	Magamedov Gandhi	01458795	95	Remblais, pharmacie remblais	Sanaev Amir	59874531	99	Anoumaba, fabrique d'attiéké	2019-10-05 13:50:40.668052	\N	1	1000	Extraits de naissance	4	1	1.387	6	\N
1923452647	1632345545	1	AS	11161616	1	MOSQUE	AYA	23232456	6	BVD	2019-10-07 14:36:48.687434	\N	2	1200	CHAUSSURE	5	1	9.048	6	\N
1923452648	1632345544	1	AS	11161616	114	MOSQUE	AYA	23232456	72	BVD	2019-10-07 14:36:57.270083	\N	2	1650	CHAUSSURE	5	1	28.372	5	\N
1923452649	1632345543	1	tenin	87610151	92	cite du personnel	la joie	57614246	72	ananeraie	2019-10-07 14:37:03.850059	\N	1	1350	extrait du gospion	2	1	17.989	6	\N
1923452646	1632345546	1	mariam	87610151	66	lonchamps	christian	57614246	72	ananeraie	2019-10-07 14:36:41.509128	\N	1	1250	facture de chaussure	-1	1	13.213	6	\N
1923452641	1632345550	1	mde oué	87610151	26	pallet	aissata	57614246	77	batim	2019-10-07 14:36:09.350736	\N	1	1200	covocation	-1	1	12.215	6	\N
1923452645	1632345547	1	la vie	87610151	2	anadors	michou	57614246	72	liberté	2019-10-07 14:36:36.143428	\N	2	1300	iphone 6	4	2	14.745	6	\N
1923452652	1632345551	1	aka	57715955	39	BON	KKB	34728964	51	CF KKB	2019-10-08 10:11:36.606775	\N	1	1200	DEPOS POLITIQUE 	-1	1	10.03	6	\N
1923452642	1632345549	1	AS	11161616	65	CHANDELIER	AYA	23232456	112	BVD	2019-10-07 14:36:16.606471	\N	2	1800	VOITURE	2	1	34.878	6	\N
1923452670	1632345556	1	Brice	45636622	94	koumassi	Jean	03256987	107	abidjan	2019-10-08 10:39:15.836086	\N	2	1400	ordinateur portable	4	2	18.1	6	\N
1923452657	1632345571	1	GBU	66666666	67	RUE 5	GBOU	66666666	105	RUE	2019-10-08 10:35:37.617474	\N	2	1550	SAC	3	2	25.178	5	\N
1923452672	1632345555	1	Brice	45636622	94	koumassi	Jean	03256987	65	cocody	2019-10-08 10:39:19.947517	\N	2	1400	ordinateur portable	3	2	19.369	6	\N
1923452667	1632345559	1	Brice	45636622	94	koumassi	Jean	03256987	115	anyama	2019-10-08 10:38:48.551137	\N	2	1800	ordinateur portable	2	2	35.644	6	\N
1923452671	1632345574	1	AMIDOU	34728964	64	BZBE	ADO	20345678	101	CF KKB	2019-10-08 10:39:16.778537	\N	2	1300	ordinateur HP	3	1	13.219	6	\N
1923452662	1632345564	1	Brice	45636622	94	koumassi	Jean	03256987	85	yopougon	2019-10-08 10:38:14.366326	\N	2	1550	sac de riz	9	2	24.364	6	\N
1923452661	1632345566	1	Brice	45636622	94	koumassi	Jean	03256987	87	treichville	2019-10-08 10:38:10.283558	\N	2	1200	sac de riz	2	2	10.394	6	\N
1923452666	1632345560	1	Brice	45636622	94	koumassi	Jean	03256987	30	adjamé	2019-10-08 10:38:42.285202	\N	2	1400	ordinateur portable	2	2	18.596	6	\N
1923452665	1632345561	1	Brice	45636622	94	koumassi	Jean	03256987	64	cocody	2019-10-08 10:38:37.289091	\N	2	1400	ordinateur portable	1	2	18.165	6	\N
1923452653	1632345558	1	kouakou	11111111	4	RUE12	MARIAM	22222222	6	RUE	2019-10-08 10:29:31.09275	\N	1	1250	EXTRAITS	8	1	14.679	6	\N
1923452668	1632345557	1	Brice	45636622	94	koumassi	Jean	03256987	114	bingerville	2019-10-08 10:39:07.099258	\N	2	1600	ordinateur portable	4	2	27.574	6	\N
1923452654	1632345565	1	ADO	33333333	41	RUE 5	HKB	33333333	64	RUE	2019-10-08 10:31:37.495201	\N	2	1150	FFCI	2	2	8.586	6	\N
1923452659	1632345570	1	president 	45636622	66	maison blanche	ouattara	03256987	87	portbouet 2	2019-10-08 10:37:52.11718	\N	2	1000	range rover	2	1	3.675	6	\N
1923452669	1632345573	1	hkb	34728964	64	BZBE	ADO	20345678	101	CF KKB	2019-10-08 10:39:11.980188	\N	2	1300	ordinateur HP	-1	1	13.219	6	\N
1923452664	1632345562	1	hkb	57715955	66	BON	KKB	34728964	51	CF KKB	2019-10-08 10:38:29.074948	\N	1	1250	dossier	8	1	13.659	6	\N
1923452656	1632345568	1	GBE	55555555	67	RUE 5	GBI	55555555	64	RUE	2019-10-08 10:34:06.900722	\N	2	1400	BAE	3	2	17.908	5	\N
1923452674	1632345554	1	aka	57715955	94	BON	KKB	34728964	51	CF KKB	2019-10-08 10:54:44.061676	\N	1	1350	DEPOS POLITIQUE 	1	1	19.85	6	\N
1923452655	1632345567	1	GBO	44444444	95	RUE 5	GBA	44444444	64	RUE	2019-10-08 10:33:05.606134	\N	2	1250	BAE	3	2	12.363	6	\N
1923452658	1632345572	1	ministre adjoumani	45636622	66	ministere	ouattara	03256987	72	portbouet 2	2019-10-08 10:37:44.776009	\N	2	1300	1 tonne de riz	9	1	13.213	6	\N
1923452675	1632345553	1	Brice	45636622	94	koumassi	Jean	03256987	75	yopougon	2019-10-08 10:54:53.428163	\N	2	1600	ordinateur portable	4	2	26.718	6	\N
1923452663	1632345563	1	Brice	45636622	94	koumassi	Jean	03256987	68	yopougon	2019-10-08 10:38:23.112889	\N	2	1550	ordinateur portable	2	2	25.174	6	\N
1923452673	1632345575	1	gbapieu	12131415	7	XXX	YA PAS LHOMME	13141516	66	amoinkro	2019-10-08 10:53:43.809431	\N	2	1400	chat braiser	7	1	19.134	5	\N
1923452660	1632345569	1	hkb	57715955	64	BON	KKB	34728964	75	CF KKB	2019-10-08 10:37:59.254568	\N	2	1400	ordinateur HP	3	1	18.09	6	\N
1923452686	1632345586	1	Jean	55215511	74	yopougon	Ouattara	78451236	86	abidjan	2019-10-08 11:13:31.914902	\N	2	1000	montre	4	2	2.008	6	\N
1923452685	1632345588	1	Jean	55215511	74	yopougon	Ouattara	78451236	84	abidjan	2019-10-08 11:13:28.682528	\N	2	1200	montre	4	2	10.661	6	\N
1923452676	1632345552	1	Brice	45636622	94	koumassi	Jean	03256987	1	abobo	2019-10-08 10:55:01.242086	\N	2	1600	ordinateur portable	4	2	26.817	6	\N
1923452705	1632345604	1	PIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII	99999999	39	Rrue5	AHIIIIIIIIIIIIIII	88888888	37	rue3	2019-10-08 11:19:27.804493	\N	1	1000	VETEMENTS	5	1	3.037	6	\N
1923452700	1632345604	1	PIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII	99999999	39	Rrue5	AHIIIIIIIIIIIIIII	88888888	37	rue3	2019-10-08 11:18:40.2145	\N	1	1000	VETEMENTS	7	1	3.037	6	\N
1923452710	1632345600	1	AMADOU	57715955	20	MOSQUE	ADO	23459870	24	ERTY	2019-10-08 11:21:01.310099	\N	2	1000	MANGUE	1	1	4.723	6	\N
1923452699	1632345602	1	PIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII	99999999	38	Rrue5	AHIIIIIIIIIIIIIII	88888888	40	rue3	2019-10-08 11:17:46.5149	\N	1	1000	VETEMENTS	6	1	2.302	6	\N
1923452704	1632345605	1	AMADOU	57715955	20	MOSQUE	ADO	23459870	24	ERTY	2019-10-08 11:19:26.573776	\N	2	1000	ORDI	1	1	4.723	6	\N
1923452687	1632345585	1	Jean	55215511	74	yopougon	Ouattara	78451236	50	abidjan	2019-10-08 11:13:35.510339	\N	2	1500	montre	2	2	22.01	6	\N
1923452698	1632345599	1	PIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII	99999999	114	Rrue5	AHIIIIIIIIIIIIIII	88888888	39	rue3	2019-10-08 11:16:43.602754	\N	1	1350	VETEMENTS	7	1	17.801	6	\N
1923452680	1632345591	1	AMADOU	32323245	20	MOSQUE	ADO	23459870	78	ERTY	2019-10-08 11:13:13.268837	\N	2	1300	CHAUSSURE	11	1	15.139	6	\N
1923452677	1632345576	1	Jean	55215511	74	yopougon	Ouattara	78451236	114	abidjan	2019-10-08 11:09:14.17759	\N	2	1700	montre	2	2	31.182	6	\N
1923452683	1632345593	1	Jean	55215511	74	yopougon	Ouattara	78451236	78	abidjan	2019-10-08 11:13:18.637983	\N	2	1550	montre	1	2	25.199	6	\N
1923452684	1632345589	1	Jean	55215511	74	yopougon	Ouattara	78451236	81	abidjan	2019-10-08 11:13:24.596728	\N	2	1000	montre	2	2	4.603	6	\N
1923452682	1632345590	1	Jean	55215511	74	yopougon	Ouattara	78451236	80	abidjan	2019-10-08 11:13:16.921473	\N	2	1150	montre	1	2	7.48	6	\N
1923452693	1632345579	1	as	32323245	20	MOSQUE	ADO	23459870	74	ERTY	2019-10-08 11:13:54.51893	\N	2	1300	CHAPEAU	1	1	14.74	6	\N
1923452688	1632345583	1	ALI	32323245	20	MOSQUE	ADO	23459870	76	ERTY	2019-10-08 11:13:41.84612	\N	2	1300	CHAUSSURE	1	1	13.109	6	\N
1923452696	1632345595	1	AMADOU	57715955	20	MOSQUE	ADO	23459870	78	ERTY	2019-10-08 11:14:33.375558	\N	2	1300	DU FOUTOU	1	1	15.139	6	\N
1923452695	1632345577	1	Jean	55215511	74	yopougon	Ouattara	78451236	37	abidjan	2019-10-08 11:14:03.957288	\N	2	1400	montre	1	2	17.429	6	\N
1923452694	1632345578	1	Jean	55215511	74	yopougon	Ouattara	78451236	39	abidjan	2019-10-08 11:13:58.125218	\N	2	1450	montre	1	2	19.597	6	\N
1923452691	1632345580	1	Jean	55215511	74	yopougon	Ouattara	78451236	42	abidjan	2019-10-08 11:13:51.941914	\N	2	1400	montre	1	2	17.932	6	\N
1923452678	1632345584	1	tchrouuuuuu	00000000	114	Rrue5	OUFFFFFFFFF	00000000	104	rue3	2019-10-08 11:11:39.782709	\N	1	1550	DOSSIERS	7	1	28.671	6	\N
1923452689	1632345582	1	AMIDOU	32323245	20	MOSQUE	ADO	23459870	76	ERTY	2019-10-08 11:13:44.348441	\N	2	1300	CHAPEAU	1	1	13.109	6	\N
1923452702	1632345603	1	AMADOU	57715955	20	MOSQUE	ADO	23459870	24	ERTY	2019-10-08 11:19:08.290451	\N	2	1000	TELEPHONE 	1	1	4.723	6	\N
1923452697	1632345596	1	tchrouuuuuu	00000000	114	Rrue5	OUFFFFFFFFF	00000000	109	rue3	2019-10-08 11:14:39.298756	\N	1	1800	DOSSIERS	8	1	42.412	6	\N
1923452703	1632345603	1	AMADOU	57715955	20	MOSQUE	ADO	23459870	24	ERTY	2019-10-08 11:19:08.291883	\N	2	1000	TELEPHONE 	4	1	4.723	6	\N
1923452708	1632345601	1	AMADOU	57715955	20	MOSQUE	ADO	23459870	24	ERTY	2019-10-08 11:20:41.957072	\N	2	1000	MONTRE	1	1	4.723	6	\N
1923452679	1632345587	1	tchrouuuuuu	00000000	114	Rrue5	OUFFFFFFFFF	00000000	107	rue3	2019-10-08 11:12:38.619656	\N	1	1700	DOSSIERS	6	1	35.616	6	\N
1923452709	1632345598	1	AMADOU	57715955	20	MOSQUE	ADO	23459870	24	ERTY	2019-10-08 11:20:55.639735	\N	2	1000	DU FOUTOU	8	1	4.723	6	\N
1923452707	1632345605	1	AMADOU	57715955	20	MOSQUE	ADO	23459870	24	ERTY	2019-10-08 11:19:55.280158	\N	2	1000	ORDI	5	1	4.723	6	\N
1923452681	1632345592	1	tchrouuuuuu	00000000	114	Rrue5	OUFFFFFFFFF	00000000	110	rue3	2019-10-08 11:13:15.648045	\N	1	1850	DOSSIERS	5	1	44.266	6	\N
1923452692	1632345594	1	tchrouuuuuu	00000000	114	Rrue5	OUFFFFFFFFF	00000000	113	rue3	2019-10-08 11:13:54.280293	\N	1	1650	DOSSIERS	3	1	33.139	6	\N
1923452701	1632345604	1	PIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII	99999999	39	Rrue5	AHIIIIIIIIIIIIIII	88888888	37	rue3	2019-10-08 11:19:08.284932	\N	1	1000	VETEMENTS	8	1	3.037	6	\N
1923452706	1632345604	1	PIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII	99999999	39	Rrue5	AHIIIIIIIIIIIIIII	88888888	37	rue3	2019-10-08 11:19:27.812458	\N	1	1000	VETEMENTS	7	1	3.037	6	\N
1923452690	1632345581	1	Jean	55215511	74	yopougon	Ouattara	78451236	46	abidjan	2019-10-08 11:13:47.281034	\N	2	1450	montre	2	2	19.585	6	\N
1923452718	1632345607	1	charmel	87610151	42	la 2	ahmed	11111111	114	bingerville	2019-10-08 15:12:04.144833	\N	2	1350	ordinateur	2	2	16.044	6	\N
1923452712	1632345292	61	emeline	08729981	12	ananerai	ALICE	08729981	89	ANANERAI	2019-10-08 11:47:48.79315	\N	1	1350	documents administratifs	5	2	18.881	6	\N
1923452713	1632345290	58	aicha	57999724	14	jziddkdkdlzzn	ouattara	09765432	105	vdizlsbsbzoall	2019-10-08 11:47:48.798314	\N	1	1600	sac et cahiers	2	2	31.405	6	\N
1923452711	1632345290	58	aicha	57999724	14	jziddkdkdlzzn	ouattara	09765432	105	vdizlsbsbzoall	2019-10-08 11:47:35.474224	\N	1	1600	sac et cahiers	2	2	31.405	6	\N
1923452714	1632345294	59	BONI	49203638	8	yopougon	Valérie Oué	49203638	21	Abidjan, Abidjan	2019-10-08 11:48:18.039994	\N	2	1350	chaussure	5	1	15.342	6	\N
1923452715	1632345295	59	valerie	49203638	1	abidjan	Boni	07145989	67	yopougon	2019-10-08 11:48:18.046466	\N	1	1300	habit	5	2	15.296	6	\N
1923452717	1632345606	58	kk	05050505	31	rue 6	hhh	04040404	67	mode	2019-10-08 15:04:30.496728	\N	2	1200	chaussures 	4	2	9.081	6	\N
1923452719	1632345608	1	han	55545555	3	samaké	hiiii	22222222	1	gare	2019-10-08 15:39:58.982525	\N	1	1000	extrait	2	1	2.844	6	\N
1923452716	1632345294	59	BONI	49203638	8	yopougon	Valérie Oué	49203638	21	Abidjan, Abidjan	2019-10-08 11:48:33.270902	\N	2	1350	chaussure	6	1	15.342	6	\N
1923452751	1632345642	1	pla	11111111	66	RUE4	COUCOU	22222222	64	RUE2	2019-10-18 11:26:11.594388	\N	2	1300	CHAINES	9	1	13.16	6	\N
1923452720	1632345609	72	Hadi	49859528	20	champs Élysée 	soualio	78830760	43	Faya 	2019-10-08 16:00:00.858689	\N	1	1200	chaussure 	2	1	10.905	6	\N
1923452729	1632345618	70	Zerbo 	89865492	115	Barbara 	Touré 	88786812	105	Borabora 	2019-10-15 09:50:18.069992	\N	2	1800	Lit 	2	1	35.046	6	\N
1923452721	1632345610	1	mariette	65656565	1	gare	aicha	25623532	72	annanéraie	2019-10-09 13:59:28.297915	\N	1	1300	livre 	23	2	16.152	6	\N
1923452737	1632345632	1	landry	57612462	40	la 2	Miss Ouattara	55555555	66	sorbonne	2019-10-18 11:19:19.94291	\N	2	1000	voiture rouge	8	2	6.956	6	\N
1923452722	1632345611	65	ADÈLE 	48561803	21	SODECI	danielle	57715955	24	SOSSO	2019-10-09 15:04:03.609496	\N	2	1000	sac a main	3	1	6.625	6	\N
1923452738	1632345628	1	mariam	57612462	40	la 2	aichou	55555555	66	sorbonne	2019-10-18 11:19:28.107167	\N	2	1000	foutou sauce graine	6	2	6.956	6	\N
1923452730	1632345619	72	Abdoul hadi 	49859528	61	angre 	soualio 	78830760	102	bietry	2019-10-15 12:30:07.175139	\N	1	1300	sac	5	1	15.69	6	\N
1923452723	1632345612	65	ass	48561803	72	annaneraie	kane	87786766	115	anyama	2019-10-10 10:08:08.598521	\N	2	1450	CHAUSSURE	2	1	20.305	6	\N
1923452731	1632345620	1	dodo(è	57715955	72	ane	nana	48561803	69	BIM	2019-10-15 15:16:44.949121	\N	2	1250	sacs a  main	4	1	10.879	6	\N
1923452724	1632345614	64	peley	42790375	42	station oil lybia	Marie Esther	57321382	8	grand marché	2019-10-10 12:05:09.366709	\N	2	1400	vêtements	8	2	18.276	6	\N
1923452725	1632345615	64	peley	07507384	98	rue 23	séphora	01010101	72	rue20	2019-10-10 12:33:45.806918	\N	1	1450	extrait	6	1	23.775	6	\N
1923452745	1632345633	1	kouassi	09100683	105	abattoir	adamo	09100685	2	anador	2019-10-18 11:24:49.377509	\N	2	1500	montre	4	1	23.455	6	\N
1923452726	1632345616	1	peley	07507384	1	samake	gor	46010111	9	mosque	2019-10-10 12:56:28.418453	\N	2	1000	facture	9	1	3.792	6	\N
1923452748	1632345641	1	pla	11111111	66	RUE4	CICI	22222222	42	RUE2	2019-10-18 11:25:29.298518	\N	2	1150	CHAINES	8	1	8.238	6	\N
1923452732	1632345621	1	MR mal	07700770	12	agb	Mr faux	09090909	18	N'doho	2019-10-16 14:50:23.175288	\N	2	1150	drouvi	6	1	8.413	6	\N
1923452734	1632345624	1	A	44444444	114	rue4	B	55555555	39	rue3	2019-10-17 09:03:55.698916	\N	2	1400	foulards	5	1	17.801	6	\N
1923452727	1632345617	1	peley	07777777	31	gendamerie	ashlet	05050505	10	eglise van	2019-10-10 13:05:28.682767	\N	2	1300	habit	4	1	15.004	6	\N
1923452728	1632345613	71	benzou	78830760	20	Williamsville rue des Champs Elysées 	diablo	79793937	10	abobo anonkoua	2019-10-15 09:40:41.627892	\N	2	1350	enveloppe 	5	1	16.989	6	\N
1923452746	1632345640	1	YOYO	22350200	3	ABOBO	JOLIE	23308040	105	PORT BOUET	2019-10-18 11:25:09.768776	\N	1	1500	EXTRAIT	0	2	26.602	6	\N
1923452742	1632345636	1	choupi	22302200	1	ABOBO	DODO	23304040	105	PORT BOUET	2019-10-18 11:22:56.6134	\N	1	1500	EXTRAIT	1	1	26.021	6	\N
1923452750	1632345639	1	kouassi	09100683	105	abattoir	koffi	09100688	4	akeikoi	2019-10-18 11:25:51.393968	\N	1	1600	certificat de nationnalité	5	2	31.345	6	\N
1923452744	1632345629	1	kouassi	09100683	105	abattoir	sangare	09100684	1	gare	2019-10-18 11:24:33.846091	\N	2	1550	chaussure	9	2	25.627	6	\N
1923452739	1632345627	1	Othniel	57612462	40	mermoz	ouattara	55555555	66	sorbonne	2019-10-18 11:19:41.67795	\N	2	1000	frite poulet	8	1	6.956	6	\N
1923452740	1632345626	1	kouakou	57612462	40	mermoz	aissata	55555555	66	sorbonne	2019-10-18 11:19:45.119998	\N	2	1000	soupe de chat	6	1	6.956	6	\N
1923452752	1632345643	1	BEN	22350222	5	ABOBO	JULIE	23408040	106	PORT BOUET	2019-10-18 11:27:07.866506	\N	2	1450	SAC	2	1	21.443	6	\N
1923452741	1632345634	1	pla	11111111	66	RUE4	DYDY	22222222	38	RUE2	2019-10-18 11:21:27.944847	\N	2	1000	CHAINES	8	1	5.691	6	\N
1923452743	1632345638	1	pla	11111111	66	RUE4	DODO	22222222	39	RUE2	2019-10-18 11:23:26.526992	\N	2	1150	CHAINES	7	1	7.517	6	\N
1923452735	1632345630	1	pla	11111111	66	RUE4	COCO	22222222	40	RUE2	2019-10-18 11:18:32.762685	\N	2	1000	BIJOUX	5	2	6.569	6	\N
1923452736	1632345631	1	melanie	57612462	40	la 2	brice	55555555	66	sorbonne	2019-10-18 11:19:14.813677	\N	2	1000	portable	1	2	6.956	6	\N
1923452754	1632345644	1	BENI	22362222	6	ABOBO	JOHN	23408040	107	PORT BOUET	2019-10-18 11:33:19.004717	\N	2	1600	CHAUSSURES	9	2	27.995	6	\N
1923452753	1632345645	1	CHERI	22362220	7	ABOBO	WENN	23408041	109	PORT BOUET	2019-10-18 11:33:10.046656	\N	2	1900	CHAUSSURES	6	1	39.231	6	\N
1923452749	1632345637	1	kouassi	09100683	105	abattoir	sylla	09100687	5	dokui	2019-10-18 11:25:37.07065	\N	1	1400	casier judiciaire	3	1	20.655	6	\N
1923452747	1632345635	1	kouassi	09100683	105	abattoir	adama	09100686	115	anyama	2019-10-18 11:25:15.658481	\N	1	1650	extrait de naissance	2	2	34.454	6	\N
1923452761	1632345647	1	yao	09100683	105	abattoir	koffi	22222222	107	gonzagueville	2019-10-18 11:53:11.508995	\N	1	1200	extrait de naissance	7	2	11.76	6	\N
1923452758	1632345651	1	yao	09100683	105	abattoir	koffi	22222222	107	gonzagueville	2019-10-18 11:52:55.701339	\N	2	1250	chaussure	3	2	11.76	6	\N
1923452759	1632345650	1	yao	09100683	105	abattoir	koffi	22222222	107	gonzagueville	2019-10-18 11:53:01.013522	\N	2	1250	chaussure	3	2	11.76	6	\N
1923452760	1632345649	1	yao	09100683	105	abattoir	koffi	22222222	107	gonzagueville	2019-10-18 11:53:05.776237	\N	2	1250	chaussure	3	2	11.76	6	\N
1923452755	1632345646	1	kouassi	07507384	1	rue2	yavo	46620546	53	rue 21	2019-10-18 11:41:20.071833	\N	1	1250	diplome	9	2	13.974	6	\N
1923452757	1632345652	1	yao	09100683	105	abattoir	koffi	22222222	107	gonzagueville	2019-10-18 11:52:39.601013	\N	2	1250	clef	3	2	11.76	6	\N
1923452763	1632345655	1	GOU	00000000	66	RUE6	CHACHA	99999999	38	RUE3	2019-10-18 11:53:27.871373	\N	1	1000	BOUCLES	6	1	5.691	6	\N
1923452733	1632345622	1	Niangoran Boua	04589713	42	Riviéra 2, rue Alpha	Mister You	56719832	26	Paillet, rue 13	2019-10-16 14:56:25.599337	\N	2	1200	Chaussures	3.5	1	9.07	6	\N
1923452762	1632345648	1	VONI	12121212	1	ABOBO	CHOUMI	30303030	107	PORT BOUET	2019-10-18 11:53:22.183828	\N	1	1650	CASIER JUDICIAIRE	0	1	34.754	6	\N
1923452764	1632345657	1	GOU	00000000	66	RUE6	CHECHE	99999999	42	RUE3	2019-10-18 11:54:28.539808	\N	1	1150	POUBELLES	5	1	8.238	6	\N
1923452765	1632345659	1	GOU	00000000	66	RUE6	CHROUCHROU	99999999	46	RUE3	2019-10-18 11:55:29.835202	\N	1	1150	LITS	4	1	9.728	6	\N
1923452772	1632345658	1	PEPE	12121215	4	ABOBO	MAMA	30303033	113	PORT BOUET	2019-10-18 11:57:44.700601	\N	1	1750	CHARTE	4	1	38.667	6	\N
1923452773	1632345656	1	JULES	12121214	2	ABOBO	PAPA	30303032	113	PORT BOUET	2019-10-18 11:57:52.954519	\N	1	1600	BULLETIN	0	1	31.296	6	\N
1923452793	1632345686	1	aissata	57612462	1	gare	tresor	22222222	7	abobo	2019-11-05 10:35:11.294437	\N	2	1000	montre	10	1	6.759	6	\N
1923452791	1632345687	62	ouattara 	57612462	1	gare 	michel	87612452	6	zoo	2019-11-05 10:12:10.204892	\N	2	1200	chaussures 	3	1	9.048	6	\N
1923452794	1632345686	1	aissata	57612462	1	gare	tresor	22222222	7	abobo	2019-11-05 10:35:34.96335	\N	2	1000	montre	10	1	6.759	6	\N
1923452784	1632345677	1	JOLI	19121214	1	ABOBO	YOYO	32303036	8	ABOBO	2019-10-18 12:12:26.293949	\N	2	1000	CHAUSSURE	7	2	3.683	6	\N
1923452783	1632345678	1	ALI	18121214	2	ABOBO	PIPI	32303036	11	ABOBO	2019-10-18 12:12:13.772589	\N	2	1200	CHAISE	9	2	10.241	6	\N
1923452768	1632345662	1	yao	09100683	105	abattoir	koffi	22222222	18	n'dotré	2019-10-18 11:57:05.414931	\N	2	1750	chaussure	5	2	34.482	6	\N
1923452770	1632345665	1	yao	09100683	105	abattoir	koffi	22222222	18	n'dotré	2019-10-18 11:57:18.272286	\N	1	1650	extrait de naissance	6	2	34.482	6	\N
1923452767	1632345661	1	yao	09100683	105	abattoir	koffi	22222222	18	n'dotré	2019-10-18 11:56:55.196656	\N	2	1750	chaussure	5	2	34.482	6	\N
1923452766	1632345660	1	yao	09100683	105	abattoir	koffi	22222222	18	n'dotré	2019-10-18 11:56:49.359673	\N	2	1750	clef	5	2	34.482	6	\N
1923452769	1632345664	1	yao	09100683	105	abattoir	koffi	22222222	18	n'dotré	2019-10-18 11:57:11.393837	\N	2	1750	montre	5	2	34.482	6	\N
1923452782	1632345679	1	KONE	17121214	3	ABOBO	LADJI	33303036	18	ABOBO	2019-10-18 12:12:01.17646	\N	2	1200	TABLE	4	2	8.732	6	\N
1923452786	1632345675	1	VAL	12121216	5	ABOBO	MEME	30303035	115	ABOBO	2019-10-18 12:12:48.174995	\N	2	1300	SAC	10	2	14.289	6	\N
1923452756	1632345653	1	GOU	00000000	66	RUE6	CHOUCOU	99999999	37	RUE3	2019-10-18 11:52:26.669008	\N	1	1000	HABITS	6	1	5.349	6	\N
1923452785	1632345676	1	DJA	12121214	5	ABOBO	PAL	30303036	8	ABOBO	2019-10-18 12:12:36.843366	\N	2	1150	MONTRE	8	2	7.667	6	\N
1923452774	1632345663	1	GOU	00000000	66	RUE6	CHICHA	99999999	46	RUE3	2019-10-18 11:57:54.150481	\N	1	1150	FAUTEUIL	3	1	9.728	6	\N
1923452777	1632345670	1	GOU	00000000	66	RUE6	CHICHA	99999999	66	RUE3	2019-10-18 12:02:25.35971	\N	1	1000	AWADJI	6	1	0	6	\N
1923452788	1632345681	70	AKWABA EXPRESS SARL	20370174	20	williamsville, croix bleue 	Linda KOUASSI	08148762	19	Saint-Michel, marché Gouro	2019-10-22 11:30:28.979901	\N	1	1000	doucument	0.015	1	5.395	5	\N
1923452775	1632345668	1	PAP	12121217	5	ABOBO	MEME	30303034	104	PORT BOUET	2019-10-18 11:59:48.700951	\N	1	1450	RECEPICE	1	1	22.839	6	\N
1923452771	1632345666	1	VIEUX	12121216	3	ABOBO	MAMAN	30303034	112	PORT BOUET	2019-10-18 11:57:22.465204	\N	1	1850	FACTURE	2	1	43.176	6	\N
1923452781	1632345674	1	GOU	00000000	66	RUE6	CHICHA	99999999	66	RUE3	2019-10-18 12:05:50.382729	\N	1	1000	BUREAU	4	1	0	6	\N
1923452778	1632345671	1	GOU	00000000	66	RUE6	CHICHA	99999999	66	RUE3	2019-10-18 12:03:11.92616	\N	1	1000	ORDINATEURS	5	1	0	6	\N
1923452776	1632345669	1	GOU	00000000	66	RUE6	CHICHA	99999999	66	RUE3	2019-10-18 12:01:26.783755	\N	1	1000	FAUTEUIL	2	1	0	6	\N
1923452780	1632345673	1	GOU	00000000	66	RUE6	CHICHA	99999999	66	RUE3	2019-10-18 12:04:54.950305	\N	1	1000	FOURNITURES	1	1	0	6	\N
1923452779	1632345672	1	GOU	00000000	66	RUE6	CHICHA	99999999	66	RUE3	2019-10-18 12:04:12.058706	\N	1	1000	BANCS	6	1	0	6	\N
1923452789	1632345682	70	AKWABA EXPRESS SARL	20370174	20	williamsville, croix bleue	Linda KOUASSI	08148762	19	Saint-Michel, marché Gouro	2019-10-22 13:21:54.386609	\N	1	1000	doucument	5	1	5.395	6	\N
1923452787	1632345680	58	Choumie	09763454	67	Selmer, institut Ifef 	Michou	76891234	102	Biétry, Centre	2019-10-18 16:44:33.849023	\N	1	1450	Sac	12	1	22.643	5	\N
1923452790	1632345684	1	tasaba	49339567	2	VOILA SA	MR GROS NEZ	48339567	24	MAIS OUIIII	2019-11-04 16:30:00.239488	\N	1	1000	bouloir	6	1	4.777	6	\N
1923452795	1632345770	1	madou	40916609	93	AVENU7	sidik	49098900	88	N'guoua	2019-11-06 09:02:59.141213	\N	2	1350	DES VELO	52	1	16.97	6	\N
1923452792	1632345685	1	aissa	57612462	1	gare	tresor	22222222	8	sogefia	2019-11-05 10:35:11.237287	\N	1	1000	bulletin	6	1	3.683	6	\N
1923452800	1632345752	1	COURSE	77777777	115	rue1	VITE	44444444	115	rue5	2019-11-06 11:09:32.364667	\N	1	1000	FOURNITURES SCOLAIRES	7	1	0	6	\N
1923452799	1632345751	1	COURSE	77777777	96	rue1	VITE	44444444	99	rue5	2019-11-06 11:08:27.516328	\N	2	1000	TEE-SHIRT	4	1	2.383	6	\N
1923452811	1632345763	58	papi	03876767	66	sgbci	toto	07000084	76	pharmacie jk	2019-11-06 11:18:37.733529	\N	1	1250	montre	2	2	14.339	6	\N
1923452798	1632345753	1	HUM	77777777	29	rue1	HAIIIIIIIIII	44444444	115	rue5	2019-11-06 11:08:14.379744	\N	1	1350	JOURNAUX	6	1	19.401	6	\N
1923452810	1632345766	1	amke 	08416609	103	AERO	sidik	09997877	115	N'guoua	2019-11-06 11:18:25.881533	\N	2	1650	ordinateur hp	5	1	29.28	6	\N
1923452805	1632345768	1	amadou	08416609	96	ARO	sidik	09997877	71	N'guoua	2019-11-06 11:17:42.940493	\N	2	1650	ordinateur hp	5	1	29.597	6	\N
1923452804	1632345769	1	madou	40916609	93	AVENU7	sidik	49098900	71	N'guoua	2019-11-06 11:17:37.411226	\N	2	1500	DES VELO	5	1	23.808	6	\N
1923452803	1632345769	1	madou	40916609	93	AVENU7	sidik	49098900	71	N'guoua	2019-11-06 11:17:34.567228	\N	2	1500	DES VELO	5	1	23.808	6	\N
1923452801	1632345769	1	madou	40916609	93	AVENU7	sidik	49098900	71	N'guoua	2019-11-06 11:17:27.430744	\N	2	1500	DES VELO	5	1	23.808	6	\N
1923452812	1632345763	58	papi	03876767	66	sgbci	toto	07000084	76	pharmacie jk	2019-11-06 11:18:43.767859	\N	1	1250	montre	6	2	14.339	6	\N
1923452796	1632345765	1	assie 	08416609	113	AERO	malik	09997877	7	N'guoua	2019-11-06 11:06:48.476543	\N	2	1600	sac 	2.5	1	27.023	6	\N
1923452806	1632345768	1	amadou	08416609	96	ARO	sidik	09997877	71	N'guoua	2019-11-06 11:17:48.011508	\N	2	1650	ordinateur hp	5	1	29.597	6	\N
1923452808	1632345767	1	amadou	08416609	96	ARO	sidik	09997877	115	N'guoua	2019-11-06 11:18:16.552648	\N	2	1700	ordinateur hp	5	1	30.65	5	\N
1923452809	1632345766	1	amke 	08416609	103	AERO	sidik	09997877	115	N'guoua	2019-11-06 11:18:21.064202	\N	2	1650	ordinateur hp	5	1	29.28	6	\N
1923452807	1632345767	1	amadou	08416609	96	ARO	sidik	09997877	115	N'guoua	2019-11-06 11:18:11.487427	\N	2	1700	ordinateur hp	5	1	30.65	6	\N
1923452815	1632345762	58	km	09454567	50	je suis la	beti	89090989	113	église st pierre	2019-11-06 11:19:04.260481	\N	1	1450	valise	8	2	23.465	6	\N
1923452820	1632345759	1	TOI KI	77777777	16	rue1	TOI TOI	44444444	20	rue5	2019-11-06 11:19:38.946232	\N	1	1200	chaises	5	1	12.497	6	\N
1923452797	1632345764	58	kk	78788906	89	sib	uyu	89089878	33	station ivoire	2019-11-06 11:07:01.529078	\N	1	1100	bijoux or	5	2	7.222	5	\N
1923452816	1632345761	58	kk	09090909	29	rue la paix 	venix	56768700	94	rue jean	2019-11-06 11:19:17.958025	\N	2	1400	facture	5	2	18.933	6	\N
1923452802	1632345769	1	madou	40916609	93	AVENU7	sidik	49098900	71	N'guoua	2019-11-06 11:17:29.109237	\N	2	1500	DES VELO	5	1	23.808	6	\N
1923452818	1632345760	58	Kouassi 	01077484	4	mosquée el hadj	sekou	46620546	72	boulangerie la pacha 	2019-11-06 11:19:28.51014	\N	1	1400	sac â main	2	2	22.116	6	\N
1923452819	1632345760	58	Kouassi 	01077484	4	mosquée el hadj	sekou	46620546	72	boulangerie la pacha 	2019-11-06 11:19:34.239328	\N	1	1400	sac â main	4	2	22.116	6	\N
1923452813	1632345762	58	km	09454567	50	je suis la	beti	89090989	113	église st pierre	2019-11-06 11:18:54.646673	\N	1	1450	valise	1	2	23.465	6	\N
1923452814	1632345762	58	km	09454567	50	je suis la	beti	89090989	113	église st pierre	2019-11-06 11:18:58.89748	\N	1	1450	valise	1.5	2	23.465	6	\N
1923452817	1632345761	58	kk	09090909	29	rue la paix 	venix	56768700	94	rue jean	2019-11-06 11:19:22.16513	\N	2	1400	facture	5	2	18.933	6	\N
1923452832	1632345745	1	MiFAGA	77777777	112	rue1	JOYA	44444444	94	rue5	2019-11-06 12:09:18.033292	\N	1	1400	SECRET	3	2	20.859	6	\N
1923452846	1632345725	1	siaka	48414540	8	ayama	mie	47859621	63	rosier	2019-11-06 12:11:16.665814	\N	1	1250	radio	5	1	12.805	6	\N
1923452837	1632345742	1	HYVI	09828375	32	macheter	pitigo	05422903	61	KOUDIO	2019-11-06 12:10:15.44348	\N	2	1450	méche	5	2	21.045	6	\N
1923452857	1632345691	1	ouattara	54871263	2	anador	amira	52146398	114	bingerville	2019-11-06 12:13:15.542979	\N	1	1500	ramme	4	1	26.767	6	\N
1923452850	1632345711	1	Miss NIONGUI	01020304	7	rue 126	M.GAEL	88888888	72	rue 14	2019-11-06 12:11:44.872069	\N	2	1450	CHEMISES	5	1	19.833	6	\N
1923452827	1632345750	1	BON 	77777777	46	rue1	QUAND	44444444	101	rue5	2019-11-06 12:08:42.758774	\N	2	1150	BASSINES	4	1	8.218	6	\N
1923452844	1632345726	1	aicha	55555555	56	attoban	ria	41414141	39	bingerville	2019-11-06 12:11:07.019296	\N	2	1000	telephone fixe	3	2	5.92	6	\N
1923452845	1632345726	1	aicha	55555555	56	attoban	ria	41414141	39	bingerville	2019-11-06 12:11:11.020449	\N	2	1000	telephone fixe	2	2	5.92	6	\N
1923452854	1632345706	1	ango	47175854	75	banco nord	mirame	49618965	66	pyramide	2019-11-06 12:12:12.488292	\N	2	1250	voiture	5	1	10.977	6	\N
1923452855	1632345705	1	carserole mamitte assiete	45556677	64	daishi	abordjoler	09996754	109	gnomi laper	2019-11-06 12:12:46.869367	\N	2	1750	valise	10	1	33.217	6	\N
1923452851	1632345709	1	Miss NIONGUI	01020304	7	rue 123	Miss MEMELLE	09080706	39	rue 12	2019-11-06 12:11:51.244278	\N	2	1300	PAGNES	5	2	14.209	6	\N
1923452826	1632345755	1	lili	77777777	54	rue1	poooooo	44444444	83	rue5	2019-11-06 12:08:31.840686	\N	1	1350	meches	3	1	17.545	5	\N
1923452848	1632345724	1	sylla	85482154	3	abobo	mie	55555555	10	anonkoua	2019-11-06 12:11:32.940435	\N	1	1150	rapport	5	1	8.207	6	\N
1923452841	1632345727	1	lekile	23334455	3	SAVA ALLER	adjigui	48339567	96	TAPR DEDANS	2019-11-06 12:10:52.493097	\N	2	1500	CHAT	5	2	22.758	6	\N
1923452852	1632345708	1	Amadou	56475432	1	dougoutiki	le gros	77889900	91	Chiiiiiiii	2019-11-06 12:11:56.721374	\N	1	1300	sac de soumara 	5	1	16.383	6	\N
1923452843	1632345728	1	méléké	23334455	91	kokota	monter decendre	48339567	96	TAPR DEDANS	2019-11-06 12:11:01.543459	\N	2	1150	calendrier	1	2	8.21	6	\N
1923452822	1632345757	1	Arafat	77777777	17	rue1	arafat	44444444	86	rue5	2019-11-06 12:08:00.990113	\N	1	1400	chaises	5	1	21.405	6	\N
1923452829	1632345748	1	MiFAGA	77777777	46	rue1	YAKOI	44444444	94	rue5	2019-11-06 12:08:56.75803	\N	2	1200	BIOUX	9	2	10.296	6	\N
1923452842	1632345728	1	méléké	23334455	91	kokota	monter decendre	48339567	96	TAPR DEDANS	2019-11-06 12:10:57.481867	\N	2	1150	calendrier	1	2	8.21	6	\N
1923452828	1632345749	1	VIENT	77777777	46	rue1	VA	44444444	101	rue5	2019-11-06 12:08:47.770905	\N	2	1150	BASSINES	8	1	8.218	6	\N
1923452836	1632345742	1	HYVI	09828375	32	macheter	pitigo	05422903	61	KOUDIO	2019-11-06 12:10:05.768885	\N	2	1450	méche	5	2	21.045	6	\N
1923452823	1632345754	1	lolo	77777777	26	rue1	lala	44444444	110	rue5	2019-11-06 12:08:12.782564	\N	1	1700	montres	56	1	36.572	6	\N
1923452858	1632345690	62	aicha	89000734	66	Sorbonne 	dani	09876543	65	cocody	2019-11-06 12:13:31.930497	\N	1	1200	mèche 	6	1	11.29	6	\N
1923452838	1632345741	1	MiFAGA	77777777	112	rue1	JOYA	44444444	93	rue5	2019-11-06 12:10:31.540819	\N	1	1550	PORTABLE	1	2	28.736	6	\N
1923452833	1632345744	1	MiFAGA	77777777	112	rue1	JOYA	44444444	94	rue5	2019-11-06 12:09:34.796323	\N	2	1450	LOGISTIK	1	2	20.859	6	\N
1923452835	1632345743	1	MiFAGA	77777777	112	rue1	JOYA	44444444	94	rue5	2019-11-06 12:09:50.544711	\N	2	1450	GESTIONNAIRE	8	2	20.859	6	\N
1923452840	1632345741	1	MiFAGA	77777777	112	rue1	JOYA	44444444	93	rue5	2019-11-06 12:10:36.362984	\N	1	1550	PORTABLE	7	2	28.736	6	\N
1923452834	1632345744	1	MiFAGA	77777777	112	rue1	JOYA	44444444	94	rue5	2019-11-06 12:09:44.46871	\N	2	1450	LOGISTIK	10	2	20.859	6	\N
1923452825	1632345756	1	Arafat	77777777	20	rue1	arafat	44444444	90	rue5	2019-11-06 12:08:26.748107	\N	1	1200	albums	5	1	10.266	6	\N
1923452853	1632345707	1	daniel	77175854	21	banco nord	mirame	49614514	64	palmeraie	2019-11-06 12:12:03.177322	\N	1	1200	PC	5	2	11.508	6	\N
1923452831	1632345746	1	MiFAGA	77777777	112	rue1	JOYA	44444444	94	rue5	2019-11-06 12:09:08.859771	\N	1	1400	MARKET	2	2	20.859	6	\N
1923452849	1632345710	1	KASS	77175887	25	sodeci	oumar	1214584_	64	riviera	2019-11-06 12:11:39.186726	\N	2	1250	bic	5	1	12.613	6	\N
1923452824	1632345756	1	Arafat	77777777	20	rue1	arafat	44444444	90	rue5	2019-11-06 12:08:18.606348	\N	1	1200	albums	5	1	10.266	6	\N
1923452830	1632345747	1	pipo	02345678	29	GALETTE	KOFFI	05422903	61	KOUDIO	2019-11-06 12:09:01.820185	\N	2	1150	BONBON	5	2	7.36	6	\N
1923452821	1632345758	1	CES MOI	77777777	19	rue1	CES TOI	44444444	90	rue5	2019-11-06 12:07:51.603606	\N	1	1000	chaises	5	1	6.662	6	\N
1923452839	1632345741	1	MiFAGA	77777777	112	rue1	JOYA	44444444	93	rue5	2019-11-06 12:10:31.637181	\N	1	1550	PORTABLE	1	2	28.736	6	\N
1923452847	1632345724	1	sylla	85482154	3	abobo	mie	55555555	10	anonkoua	2019-11-06 12:11:28.787632	\N	1	1150	rapport	5	1	8.207	6	\N
1923452863	1632345688	62	fee	 7612462	68	siporex 	mia	66666669	99	anoumabo	2019-11-06 12:14:14.624585	\N	2	1450	tissage 	5	2	19.759	5	\N
1923452856	1632345705	1	carserole mamitte assiete	45556677	64	daishi	abordjoler	09996754	109	gnomi laper	2019-11-06 12:13:05.924774	\N	2	1750	valise	10	1	33.217	6	\N
1923452859	1632345690	62	aicha	89000734	66	Sorbonne 	dani	09876543	65	cocody	2019-11-06 12:13:35.646439	\N	1	1200	mèche 	5	1	11.29	6	\N
1923452861	1632345689	62	sali	56789022	20	willy 	sara	34215678	61	angre 	2019-11-06 12:13:56.98733	\N	2	1000	jean	5	2	6.659	6	\N
1923452860	1632345692	1	mael	87952314	22	dallas	rafi	74859613	107	gonzagueville	2019-11-06 12:13:46.298311	\N	2	1500	t-shirte	5	1	22.401	6	\N
1923452862	1632345692	1	mael	87952314	22	dallas	rafi	74859613	107	gonzagueville	2019-11-06 12:14:07.858213	\N	2	1500	t-shirte	5	1	22.401	6	\N
1923452879	1632345723	1	ADO	00202123	40	MERM	BENOIR	34729708	61	CEP1	2019-11-06 13:01:23.994125	\N	1	1000	Lettre de demition 	5	1	6.07	6	\N
1923452885	1632345698	1	pathie	47172854	76	gesco	mariam	52478965	99	anoumabo	2019-11-06 13:02:43.874802	\N	1	1450	carton de patte	9	2	22.926	6	\N
1923452897	1632345704	65	Monique	48561803	20	rambo 	VIVI	59061324	114	LG 	2019-11-06 13:07:17.704413	\N	2	1450	micro onde	1	1	21.122	6	\N
1923452898	1632345704	65	Monique	48561803	20	rambo 	VIVI	59061324	114	LG 	2019-11-06 13:07:38.344699	\N	2	1450	micro onde	8	1	21.122	6	\N
1923452899	1632345716	1	Miss NIONGUI	14141414	115	rue 126	MIMI	00000000	68	rue 14	2019-11-06 13:07:57.585397	\N	2	1500	JOUETS ET POUPEES	4	1	22.537	6	\N
1923452887	1632345697	1	mouton premier 	08729982	78	MOUSSO FIMAN	cabri deusieme	08729983	25	AMANANKATA	2019-11-06 13:02:53.562555	\N	2	1300	valise	8	1	13.311	5	\N
1923452868	1632345737	1	kouadio	00000000	4	akeikoi	koussi	02514893	101	zone 4c	2019-11-06 13:00:03.035188	\N	1	1500	une bouteille de vin	4	2	27.479	6	\N
1923452901	1632345717	1	MAIMOUNA	33333333	115	rue 126	CHICHIA	99999999	68	rue 14	2019-11-06 13:08:11.748567	\N	2	1500	CLIMATISSEURS	10	1	22.537	6	\N
1923452894	1632345714	1	Miss NIONGUI	14141414	115	rue 126	MIMI	00000000	68	rue 14	2019-11-06 13:06:40.346294	\N	2	1500	DECO ET ACCESSOIRES	5	1	22.537	6	\N
1923452888	1632345696	1	pantcho	47172803	72	nouveau marche	tantie	72145562	95	remblais	2019-11-06 13:03:01.825267	\N	2	1450	carton de papier HP	10	1	21.598	6	\N
1923452890	1632345702	1	ange	47175854	76	gesco	mirame	49618965	99	anoumabo	2019-11-06 13:06:00.325805	\N	2	1500	miel	1	1	22.926	6	\N
1923452870	1632345735	1	rachida	02125478	66	plateau	maria	14785962	96	port bouet 2	2019-11-06 13:00:15.695724	\N	1	1150	album photo	3	2	8.185	6	\N
1923452867	1632345737	1	kouadio	00000000	4	akeikoi	koussi	02514893	101	zone 4c	2019-11-06 12:59:57.658453	\N	1	1500	une bouteille de vin	2	2	27.479	6	\N
1923452876	1632345730	1	Miss NIONGUI	66666666	110	rue 126	PIPO	99999999	114	rue 14	2019-11-06 13:00:54.696793	\N	2	2000	PHOTOCOPIEUSES	10	2	43.701	5	\N
1923452886	1632345697	1	mouton premier 	08729982	78	MOUSSO FIMAN	cabri deusieme	08729983	25	AMANANKATA	2019-11-06 13:02:49.527599	\N	2	1300	valise	7	1	13.311	5	\N
1923452866	1632345738	1	konan	00000025	114	bingerville	kouassi	584965__	101	zone 4c	2019-11-06 12:59:50.450828	\N	1	1400	pagne	5	2	22.363	6	\N
1923452864	1632345740	1	pabmo escoba	09828375	78	POUPI	LEBEdher	05422903	102	KOUDIO	2019-11-06 12:59:34.018448	\N	2	1000	calendrier	1	2	3.648	6	\N
1923452891	1632345703	1	mamite	08887748	68	chez zongo	zogorda la legende	09996754	105	aweler katier	2019-11-06 13:06:14.575691	\N	2	1500	valise	8	1	23.696	6	\N
1923452865	1632345739	1	kong ARRIVE	56889967	82	bouba	monter decendre	77889945	102	DEMARER TI MOTO	2019-11-06 12:59:44.293074	\N	2	1650	calendrier	1	2	28.423	6	\N
1923452880	1632345722	1	adja sylla	77777777	84	zone	miriame	33333333	69	bimbresso	2019-11-06 13:01:31.13284	\N	2	1300	pagne	2	1	13.814	6	\N
1923452884	1632345699	1	pintate rase	08887768	75	MOUSSO GBê	sougouya	09996754	41	attrape ton maris	2019-11-06 13:02:33.976152	\N	2	1400	valise	10	1	17.427	6	\N
1923452873	1632345733	1	kong	56889967	85	POPLA	monter decendre	77889945	102	DEMARER TI MOTO	2019-11-06 13:00:31.641004	\N	2	1450	calendrier	1	2	19.977	6	\N
1923452881	1632345721	1	latifa	99999999	84	riviera 2	issouf	22222222	23	mosquee	2019-11-06 13:01:48.899188	\N	1	1150	devis	1	2	8.455	5	\N
1923452889	1632345695	1	ami	52147803	72	annaneraie	charly	72185622	93	chu	2019-11-06 13:03:08.113876	\N	1	1300	ordornance	0.6	2	15.058	6	\N
1923452892	1632345703	1	mamite	08887748	68	chez zongo	zogorda la legende	09996754	105	aweler katier	2019-11-06 13:06:24.457242	\N	2	1500	valise	10	1	23.696	6	\N
1923452875	1632345731	1	Miss NIONGUI	66666666	110	rue 126	POPI	99999999	114	rue 14	2019-11-06 13:00:49.464404	\N	2	2000	TELEPHONE MACHINES A COUDRES	8	2	43.701	5	\N
1923452900	1632345718	1	MAIMOUNA	33333333	107	rue 126	CHouchou	99999999	105	rue 14	2019-11-06 13:08:05.240388	\N	2	1250	fauteuils	10	1	11.222	6	\N
1923452895	1632345715	1	dindon 	45556677	62	mais ouiiiiiiii	maria mobile	09996754	109	gnomi laper	2019-11-06 13:06:42.930706	\N	2	1850	valise	10	1	38.405	6	\N
1923452896	1632345712	1	Miss NIONGUI	14141414	113	rue 126	M.AWA	99999999	30	rue 14	2019-11-06 13:06:55.153197	\N	2	1450	CHEMISES	4	1	21.251	5	\N
1923452893	1632345713	1	fidel	49066609	39	lentorkro	infidel	34729708	66	BAD	2019-11-06 13:06:36.675215	\N	1	1000	Casier juridique  	1	2	6.712	6	\N
1923452872	1632345734	1	Miss NIONGUI	00000000	102	rue1	BIBI	44444444	95	rue5	2019-11-06 13:00:27.610931	\N	1	1000	FOURNITURES DE BUREAUX	10	2	4.776	6	\N
1923452877	1632345729	1	djorgouiiiiiiiii	67889900	88	POPLA	monter decendre	48339567	99	petit poto	2019-11-06 13:01:10.673007	\N	2	1300	calendrier	1	2	13.581	6	\N
1923452871	1632345734	1	Miss NIONGUI	00000000	102	rue1	BIBI	44444444	95	rue5	2019-11-06 13:00:23.592515	\N	1	1000	FOURNITURES DE BUREAUX	1	2	4.776	6	\N
1923452878	1632345729	1	djorgouiiiiiiiii	67889900	88	POPLA	monter decendre	48339567	99	petit poto	2019-11-06 13:01:17.003043	\N	2	1300	calendrier	1	2	13.581	6	\N
1923452902	1632345720	1	ladji	88888888	42	riviera 2	issouf	11111111	23	mosquee	2019-11-06 13:08:29.844057	\N	2	1200	sac de riz	7.5	2	10.054	5	\N
1923452874	1632345732	1	Miss NIONGUI	66666666	88	rue 126	TITI	00000000	93	rue 14	2019-11-06 13:00:35.79161	\N	2	1350	VELOS 	10	2	16.773	6	\N
1923452907	1632345772	81	Dev	08701654	81	Boulangerie nouvelle Jérusalem 	Estelle	47725712	64	Collège saint viateur	2019-11-11 10:04:33.286674	\N	2	1500	Tasse	0	2	23.14	6	\N
1923452916	1632345782	1	lami	12696457	1	ETG	alpha	86367588	22	TRU	2019-11-18 15:27:22.239387	\N	2	1300	PORTABLE	5	1	13.627	6	\N
1923452917	1632345783	1	mohamed	67893414	94	rue 12	fatim	01365357	74	rue 5	2019-11-20 09:12:33.538208	\N	2	1700	pc	4	1	30.557	5	\N
1923452910	1632345776	82	Dane amani	09783919	5	pharmacie dokui 	yopougon 	07666784	72	yopougon toit rouge 	2019-11-12 15:42:02.594532	\N	1	1250	bracelet 	4	2	14.051	6	\N
1923452909	1632345777	1	dja	21212121	20	rue3	SIKI	21212121	23	rue7	2019-11-11 15:34:05.705182	\N	2	1000	PAGNES	4	1	4.982	6	\N
1923452882	1632345700	65	ASSIE	57715955	20	Marseille	N'dri	48489708	114	gourokro	2019-11-06 13:02:11.695362	\N	2	1450	portable marque iphone	3	1	21.122	6	\N
1923452908	1632345773	1	ouattara	5252525_	67	selmer	aicha	20123210	41	riviera1	2019-11-11 11:11:10.395076	\N	2	1400	tass	1	1	17.654	6	\N
1923452911	1632345774	82	Dane Amani	09783919	5	pharmacie dokui 	angré 7eme tranche	87775256	61	7eme tranche 	2019-11-12 16:16:24.973677	\N	1	1000	bracelet 	2	2	6.367	6	\N
1923452906	1632345693	1	mikal	84155231	17	bellville	chantal	78459613	104	gonzagueville	2019-11-06 13:10:12.827917	\N	1	1500	extrait	4	1	25.227	6	\N
1923452905	1632345694	1	amed	84165231	68	siporex	chantou	72159613	104	vridi	2019-11-06 13:10:09.829973	\N	2	1450	portable	2	2	20.291	6	\N
1923452883	1632345701	1	lion bancale	08887748	71	casé cous	mimi la go	09996754	105	c'est gatté naninan	2019-11-06 13:02:26.489507	\N	2	1700	valise	6	1	32.566	6	\N
1923452912	1632345778	1	bou	33333333	20	rue0	SIKI	33333333	23	rue2	2019-11-13 10:29:00.350317	\N	2	1000	PAGNE	4	1	4.982	6	\N
1923452903	1632345719	1	adou	49066609	44	dfg	douclou	34729708	70	ABC	2019-11-06 13:08:31.076624	\N	2	1650	DODO	4	1	29.924	6	\N
1923452904	1632345719	1	adou	49066609	44	dfg	douclou	34729708	70	ABC	2019-11-06 13:08:38.836945	\N	2	1650	DODO	4	1	29.924	6	\N
1923452869	1632345736	1	rachida	10256548	19	adjame	mari	14785945	74	koute	2019-11-06 13:00:06.985785	\N	1	1300	photo	2	1	16.618	6	\N
1923452913	1632345779	62	chansia	09876543	1	gare	Abdoul 	65765436	37	danga	2019-11-18 10:16:56.905825	\N	1	1250	pc	2	1	14.407	6	\N
1923452914	1632345780	1	chamsiya	01924617	20	djeni kobenan	madjid	41109085	19	marche gouro	2019-11-18 14:15:04.156493	\N	2	1000	une robe	3	1	5.388	6	\N
1923452915	1632345781	1	assa	77888145	2	rue10	binette	66704246	7	voyu	2019-11-18 14:44:09.636327	\N	2	1000	colis	4	1	5.563	6	\N
\.


--
-- TOC entry 3124 (class 0 OID 18280)
-- Dependencies: 224
-- Data for Name: shipments_history; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.shipments_history (shipment_id, shipment_state_id, time_inserted, area_id) FROM stdin;
1923452359	1	2019-09-02 11:39:27.3288	64
1923452359	2	2019-09-02 18:14:08.493041	64
1923452359	5	2019-09-02 18:14:26.689578	64
1923452360	1	2019-09-04 12:10:01.389818	37
1923452361	1	2019-09-04 12:10:20.780265	28
1923452362	1	2019-09-04 12:15:23.514533	21
1923452363	1	2019-09-04 12:19:51.459761	95
1923452363	2	2019-09-04 12:20:21.371984	95
1923452363	5	2019-09-04 12:20:30.959038	95
1923452363	4	2019-09-04 12:20:49.826847	20
1923452363	5	2019-09-04 12:21:00.125945	20
1923452360	2	2019-09-04 12:22:47.519618	64
1923452360	5	2019-09-04 12:23:01.185763	64
1923452360	4	2019-09-04 12:24:01.69253	1
1923452360	6	2019-09-04 12:24:16.660094	1
1923452364	1	2019-09-04 12:42:21.658467	29
1923452365	1	2019-09-04 12:53:19.522126	66
1923452366	1	2019-09-04 12:53:30.931208	66
1923452365	2	2019-09-04 12:55:27.578627	19
1923452366	2	2019-09-04 13:00:55.145366	19
1923452365	5	2019-09-04 13:01:03.646404	19
1923452365	4	2019-09-04 13:01:17.586755	1
1923452367	1	2019-09-04 17:43:59.82115	23
1923452367	2	2019-09-04 17:49:45.468083	20
1923452367	6	2019-09-04 17:50:09.332552	20
1923452365	6	2019-09-04 17:53:01.356033	1
1923452364	2	2019-09-04 17:56:24.211114	20
1923452364	5	2019-09-04 17:56:33.83708	20
1923452364	4	2019-09-04 17:57:26.460571	64
1923452364	6	2019-09-04 17:57:47.668047	64
1923452368	1	2019-09-04 18:07:17.118202	1
1923452368	2	2019-09-04 18:07:36.378663	1
1923452368	5	2019-09-04 18:08:11.175849	1
1923452368	4	2019-09-04 18:08:24.846947	95
1923452368	6	2019-09-04 18:08:33.168589	95
1923452369	1	2019-09-04 18:10:49.595367	95
1923452369	2	2019-09-04 18:11:26.226964	95
1923452369	5	2019-09-04 18:11:32.24794	95
1923452369	4	2019-09-04 18:11:53.827471	107
1923452369	7	2019-09-04 18:12:01.727809	107
1923452369	6	2019-09-04 18:12:25.751835	107
1923452361	2	2019-09-06 10:46:35.162654	20
1923452361	5	2019-09-06 10:46:50.019858	20
1923452362	2	2019-09-06 10:49:35.541777	20
1923452366	5	2019-09-06 10:59:32.410533	19
1923452366	4	2019-09-06 10:59:47.910613	1
1923452366	6	2019-09-06 11:00:20.932719	1
1923452363	4	2019-09-06 11:02:51.671105	95
1923452363	5	2019-09-06 11:03:35.806824	95
1923452363	4	2019-09-06 11:03:58.676204	20
1923452363	6	2019-09-06 11:04:13.741403	20
1923452362	5	2019-09-06 11:04:29.355428	20
1923452362	4	2019-09-06 11:04:42.386138	95
1923452362	7	2019-09-06 11:04:49.947104	95
1923452362	6	2019-09-06 11:05:04.787847	95
1923452370	1	2019-09-06 11:15:54.405978	65
1923452371	1	2019-09-06 11:19:25.097245	114
1923452372	1	2019-09-06 11:22:34.476121	115
1923452372	2	2019-09-06 11:29:36.374399	1
1923452372	5	2019-09-06 11:29:44.485289	1
1923452372	4	2019-09-06 11:29:54.516673	95
1923452372	6	2019-09-06 11:36:51.373419	95
1923452371	2	2019-09-06 11:41:57.657049	64
1923452371	5	2019-09-06 11:42:25.105864	64
1923452371	4	2019-09-06 11:42:35.634791	1
1923452371	6	2019-09-06 11:50:10.329352	1
1923452370	2	2019-09-06 11:51:58.449958	64
1923452370	6	2019-09-06 11:52:45.20515	64
1923452373	1	2019-09-06 12:00:56.85659	75
1923452373	2	2019-09-06 12:04:20.067904	67
1923452373	5	2019-09-06 12:04:39.119942	67
1923452373	4	2019-09-06 12:04:49.037291	64
1923452373	6	2019-09-06 12:05:18.78998	64
1923452374	1	2019-09-06 12:06:31.471965	54
1923452374	2	2019-09-06 12:08:47.834725	64
1923452374	5	2019-09-06 12:09:04.70119	64
1923452374	4	2019-09-06 12:09:29.118821	20
1923452374	6	2019-09-06 12:10:14.100602	20
1923452375	1	2019-09-06 12:10:32.902269	99
1923452375	2	2019-09-06 12:11:01.038793	95
1923452375	5	2019-09-06 12:11:06.793855	95
1923452375	4	2019-09-06 12:11:20.898366	107
1923452375	6	2019-09-06 12:11:58.631031	107
1923452376	1	2019-09-06 12:12:39.932063	8
1923452376	2	2019-09-06 12:13:23.870853	1
1923452376	5	2019-09-06 12:13:29.262677	1
1923452376	4	2019-09-06 12:13:41.830405	95
1923452376	6	2019-09-06 12:13:50.730003	95
1923452377	1	2019-09-06 12:14:35.126511	115
1923452377	2	2019-09-06 12:14:51.307611	1
1923452377	5	2019-09-06 12:15:07.700945	1
1923452377	4	2019-09-06 12:15:19.888451	19
1923452377	6	2019-09-06 12:15:28.711082	19
1923452378	1	2019-09-06 12:40:08.40159	66
1923452378	2	2019-09-06 12:40:34.631479	19
1923452378	5	2019-09-06 12:40:43.553386	19
1923452378	4	2019-09-06 12:40:53.204204	64
1923452378	6	2019-09-06 12:41:01.985977	64
1923452379	1	2019-09-10 12:15:08.997888	3
1923452380	1	2019-09-10 12:15:14.528736	21
1923452381	1	2019-09-10 12:15:21.506674	87
1923452382	1	2019-09-10 12:15:25.267822	85
1923452383	1	2019-09-10 12:15:28.839325	115
1923452384	1	2019-09-10 12:18:42.546452	3
1923452380	2	2019-09-10 14:35:26.683019	20
1923452380	5	2019-09-10 14:35:38.12595	20
1923452380	4	2019-09-10 14:36:13.095176	19
1923452380	6	2019-09-10 14:37:01.948553	19
1923452384	2	2019-09-10 14:38:23.394848	1
1923452384	5	2019-09-10 14:38:30.9905	1
1923452383	2	2019-09-10 14:41:36.41087	1
1923452383	5	2019-09-10 14:41:46.828746	1
1923452383	4	2019-09-10 14:41:56.730441	19
1923452383	6	2019-09-10 14:42:07.067901	19
1923452379	2	2019-09-10 14:43:24.589414	1
1923452379	5	2019-09-10 14:43:31.068133	1
1923452379	4	2019-09-10 14:44:04.283999	67
1923452379	6	2019-09-10 14:44:34.534073	67
1923452382	2	2019-09-10 14:45:56.891343	67
1923452382	5	2019-09-10 14:46:06.898762	67
1923452382	4	2019-09-10 14:46:27.800351	64
1923452382	6	2019-09-10 14:46:34.958235	64
1923452381	2	2019-09-10 14:50:54.56813	95
1923452381	6	2019-09-10 14:51:18.985408	95
1923452385	1	2019-09-19 09:10:18.268052	21
1923452385	2	2019-09-19 09:12:17.761894	20
1923452385	5	2019-09-19 09:13:56.432664	20
1923452386	1	2019-09-19 09:19:01.500425	47
1923452386	2	2019-09-19 09:24:50.472657	64
1923452386	5	2019-09-19 09:25:41.137993	64
1923452386	4	2019-09-19 09:26:38.462004	67
1923452386	6	2019-09-19 09:29:05.849282	67
1923452387	1	2019-09-20 10:15:23.787845	86
1923452388	1	2019-09-20 10:16:03.06521	2
1923452389	1	2019-09-20 10:16:28.178762	3
1923452390	1	2019-09-20 10:16:52.223712	87
1923452391	1	2019-09-20 10:17:07.341889	87
1923452392	1	2019-09-20 10:17:57.277574	20
1923452393	1	2019-09-20 10:21:03.223595	66
1923452394	1	2019-09-20 10:23:25.570291	104
1923452395	1	2019-09-20 10:25:06.582584	65
1923452390	2	2019-09-20 10:47:50.310971	95
1923452388	2	2019-09-20 10:47:51.336419	1
1923452393	2	2019-09-20 10:47:55.493311	19
1923452395	2	2019-09-20 10:48:23.516394	64
1923452387	2	2019-09-20 10:48:29.847893	67
1923452394	2	2019-09-20 10:48:35.400466	107
1923452390	5	2019-09-20 10:54:44.124352	95
1923452393	5	2019-09-20 10:55:10.876941	19
1923452394	5	2019-09-20 10:55:23.696462	107
1923452387	5	2019-09-20 10:56:51.075584	67
1923452388	5	2019-09-20 10:57:02.72997	1
1923452396	1	2019-09-20 11:08:26.940654	98
1923452396	2	2019-09-20 11:09:11.13096	95
1923452397	1	2019-09-20 11:11:59.574501	82
1923452397	2	2019-09-20 11:12:48.152931	67
1923452397	5	2019-09-20 11:13:04.37063	67
1923452397	4	2019-09-20 11:14:00.05565	1
1923452398	1	2019-09-20 11:17:42.658845	21
1923452398	2	2019-09-20 11:18:14.035448	20
1923452398	5	2019-09-20 11:18:19.938374	20
1923452398	4	2019-09-20 11:19:16.941471	107
1923452399	1	2019-09-20 11:21:10.965855	22
1923452399	2	2019-09-20 11:21:29.581556	20
1923452399	5	2019-09-20 11:21:34.383868	20
1923452399	4	2019-09-20 11:22:29.494244	67
1923452400	1	2019-09-20 11:24:25.803826	28
1923452400	2	2019-09-20 11:24:59.48809	20
1923452400	5	2019-09-20 11:26:34.651448	20
1923452400	4	2019-09-20 11:26:40.480628	19
1923452396	6	2019-09-20 11:34:35.805077	95
1923452397	6	2019-09-20 11:34:36.619795	1
1923452398	6	2019-09-20 11:34:42.30313	107
1923452399	6	2019-09-20 11:34:48.938614	67
1923452400	6	2019-09-20 11:34:52.00849	19
1923452395	6	2019-09-20 11:34:54.316663	64
1923452401	1	2019-09-20 11:56:56.898122	37
1923452402	1	2019-09-20 11:57:12.550667	70
1923452403	1	2019-09-20 11:57:25.453093	66
1923452404	1	2019-09-20 11:57:41.242722	5
1923452405	1	2019-09-20 11:58:01.140323	12
1923452406	1	2019-09-20 11:58:09.460341	82
1923452407	1	2019-09-20 11:58:13.160782	105
1923452408	1	2019-09-20 11:58:28.237929	102
1923452409	1	2019-09-20 11:58:28.97098	102
1923452410	1	2019-09-20 11:58:29.670436	102
1923452407	2	2019-09-20 12:01:03.435051	107
1923452402	2	2019-09-20 12:01:06.502673	67
1923452410	2	2019-09-20 12:01:19.553215	95
1923452403	2	2019-09-20 12:01:23.192232	19
1923452405	2	2019-09-20 12:01:34.283206	1
1923452401	2	2019-09-20 12:01:36.558877	64
1923452410	7	2019-09-20 12:06:24.748329	95
1923452403	7	2019-09-20 12:06:26.14587	19
1923452402	7	2019-09-20 12:06:26.677284	67
1923452407	7	2019-09-20 12:06:26.748004	107
1923452405	7	2019-09-20 12:06:27.000898	1
1923452401	7	2019-09-20 12:06:29.741815	64
1923452411	1	2019-09-20 12:36:29.347102	23
1923452412	1	2019-09-20 12:36:30.943641	23
1923452413	1	2019-09-20 12:36:45.342689	1
1923452414	1	2019-09-20 12:37:18.923764	72
1923452415	1	2019-09-20 12:37:25.190297	1
1923452416	1	2019-09-20 12:37:31.119592	1
1923452417	1	2019-09-20 12:37:44.744107	19
1923452418	1	2019-09-20 12:39:04.416928	24
1923452419	1	2019-09-20 14:59:23.597246	65
1923452419	2	2019-09-20 15:01:29.102643	64
1923452419	6	2019-09-20 15:02:58.235339	64
1923452401	6	2019-09-20 15:03:09.434476	64
1923452420	1	2019-09-20 16:06:03.993073	30
1923452421	1	2019-09-20 16:26:36.796359	72
1923452403	5	2019-09-23 08:29:49.762951	19
1923452422	1	2019-09-23 09:06:36.315132	20
1923452421	2	2019-09-23 09:22:31.51407	67
1923452423	1	2019-09-23 11:23:47.686804	105
1923452424	1	2019-09-23 11:31:04.145808	11
1923452425	1	2019-09-23 11:31:04.148637	11
1923452426	1	2019-09-23 11:48:43.813856	82
1923452427	1	2019-09-23 11:56:59.977201	20
1923452427	2	2019-09-23 13:46:47.769481	20
1923452392	2	2019-09-23 13:51:18.851565	20
1923452406	2	2019-09-23 13:55:57.825297	67
1923452428	1	2019-09-23 14:34:41.212671	65
1923452428	2	2019-09-23 14:37:18.282756	64
1923452428	6	2019-09-23 14:43:07.271903	64
1923452420	2	2019-09-24 09:35:27.453856	20
1923452420	5	2019-09-24 09:36:14.995384	20
1923452422	2	2019-09-24 09:50:35.128963	20
1923452422	5	2019-09-24 09:50:45.934696	20
1923452422	4	2019-09-24 09:51:26.777505	67
1923452429	1	2019-09-24 11:07:13.445468	66
1923452430	1	2019-09-24 11:07:30.495321	8
1923452431	1	2019-09-24 11:07:40.39313	65
1923452432	1	2019-09-24 11:07:53.258572	8
1923452431	2	2019-09-24 11:58:38.698088	64
1923452389	2	2019-09-24 11:58:38.77012	1
1923452391	2	2019-09-24 11:58:42.157727	95
1923452429	2	2019-09-24 11:58:49.79592	19
1923452431	5	2019-09-24 12:01:56.698968	64
1923452389	5	2019-09-24 12:05:18.2078	1
1923452391	5	2019-09-24 12:05:18.313221	95
1923452429	5	2019-09-24 12:05:21.987781	19
1923452410	4	2019-09-24 12:07:45.490801	64
1923452433	1	2019-09-24 12:09:54.391245	21
1923452411	2	2019-09-24 12:10:28.249624	20
1923452433	2	2019-09-24 12:11:12.369752	20
1923452433	5	2019-09-24 12:11:23.578264	20
1923452433	4	2019-09-24 12:12:38.226186	95
1923452434	1	2019-09-24 12:15:11.860662	21
1923452434	2	2019-09-24 12:15:40.729467	20
1923452434	5	2019-09-24 12:15:51.490428	20
1923452434	4	2019-09-24 12:16:51.424907	19
1923452435	1	2019-09-24 12:18:37.411953	28
1923452435	2	2019-09-24 12:18:56.141566	20
1923452435	5	2019-09-24 12:19:11.778305	20
1923452435	4	2019-09-24 12:19:53.140323	1
1923452436	1	2019-09-24 12:21:38.431008	29
1923452436	2	2019-09-24 12:22:04.205335	20
1923452436	5	2019-09-24 12:22:15.62751	20
1923452436	4	2019-09-24 12:23:01.490705	64
1923452433	6	2019-09-24 12:28:30.787537	95
1923452434	6	2019-09-24 12:28:34.351852	19
1923452435	6	2019-09-24 12:28:38.633187	1
1923452436	6	2019-09-24 12:28:39.933825	64
1923452429	4	2019-09-24 13:25:57.257378	19
1923452429	5	2019-09-24 13:27:24.416028	19
1923452405	6	2019-09-24 13:27:55.964529	1
1923452404	2	2019-09-24 13:29:00.406097	1
1923452404	5	2019-09-24 13:30:10.641996	1
1923452413	2	2019-09-24 13:41:07.463987	1
1923452413	6	2019-09-24 13:42:15.954452	1
1923452437	1	2019-09-24 13:58:27.401894	93
1923452438	1	2019-09-24 13:58:30.014731	8
1923452439	1	2019-09-24 13:58:31.619339	66
1923452440	1	2019-09-24 13:58:42.166898	76
1923452438	2	2019-09-24 14:00:15.522041	1
1923452437	2	2019-09-24 14:00:17.6419	95
1923452439	2	2019-09-24 14:00:21.278452	19
1923452441	1	2019-09-24 14:00:46.019885	2
1923452442	1	2019-09-24 14:00:50.473409	65
1923452440	2	2019-09-24 14:01:32.42774	67
1923452442	2	2019-09-24 14:01:42.047062	64
1923452438	6	2019-09-24 14:02:59.886333	1
1923452442	6	2019-09-24 14:03:00.104342	64
1923452439	6	2019-09-24 14:03:00.583245	19
1923452437	6	2019-09-24 14:03:03.700077	95
1923452440	6	2019-09-24 14:03:18.075711	67
1923452443	1	2019-09-24 14:08:52.788477	95
1923452444	1	2019-09-24 14:08:54.070743	41
1923452445	1	2019-09-24 14:10:21.682258	76
1923452446	1	2019-09-24 14:10:22.679756	1
1923452447	1	2019-09-24 14:10:27.91525	1
1923452448	1	2019-09-24 14:10:47.291172	66
1923452449	1	2019-09-24 14:10:49.900075	66
1923452448	2	2019-09-24 14:25:29.872573	19
1923452448	6	2019-09-24 14:26:50.231654	19
1923452449	2	2019-09-24 14:29:41.14955	19
1923452444	2	2019-09-24 14:35:57.58188	64
1923452450	1	2019-09-24 14:36:20.948528	65
1923452451	1	2019-09-24 14:36:24.377423	66
1923452450	2	2019-09-24 14:38:03.072335	64
1923452451	2	2019-09-24 14:38:03.141169	19
1923452450	6	2019-09-24 14:40:04.383888	64
1923452451	6	2019-09-24 14:41:08.967148	19
1923452423	2	2019-09-24 16:09:04.781535	107
1923452452	1	2019-09-24 16:09:09.928898	17
1923452453	1	2019-09-24 16:13:29.197811	20
1923452454	1	2019-09-24 16:27:59.017073	88
1923452453	2	2019-09-24 16:29:23.584679	20
1923452453	5	2019-09-24 16:30:28.071047	20
1923452454	2	2019-09-24 16:32:12.836199	95
1923452454	6	2019-09-24 16:34:43.900085	95
1923452455	1	2019-09-25 09:17:59.78317	59
1923452455	2	2019-09-25 09:18:51.557961	64
1923452455	5	2019-09-25 09:20:05.004606	64
1923452444	6	2019-09-25 09:20:56.915777	64
1923452456	1	2019-09-25 09:26:26.450074	39
1923452456	2	2019-09-25 09:28:03.949704	64
1923452456	5	2019-09-25 09:29:33.548026	64
1923452424	2	2019-09-25 10:09:50.489045	1
1923452424	5	2019-09-25 10:10:59.079933	1
1923452457	1	2019-09-25 10:11:01.601916	8
1923452447	2	2019-09-25 10:12:12.356539	1
1923452447	6	2019-09-25 10:13:08.91988	1
1923452457	2	2019-09-25 10:15:22.738781	1
1923452457	5	2019-09-25 10:15:54.233229	1
1923452458	1	2019-09-25 10:24:42.040241	1
1923452458	2	2019-09-25 10:29:36.675326	1
1923452458	5	2019-09-25 10:30:36.495437	1
1923452459	1	2019-09-25 10:48:35.871144	82
1923452460	1	2019-09-25 10:48:49.183166	87
1923452461	1	2019-09-25 10:49:16.782144	38
1923452459	2	2019-09-25 10:49:23.199587	67
1923452462	1	2019-09-25 10:49:48.604136	66
1923452460	2	2019-09-25 10:49:48.770681	95
1923452462	2	2019-09-25 10:50:18.470687	19
1923452462	6	2019-09-25 10:50:51.041856	19
1923452463	1	2019-09-25 10:50:55.245336	1
1923452460	5	2019-09-25 10:51:27.706942	95
1923452461	2	2019-09-25 10:51:35.821586	64
1923452463	2	2019-09-25 10:53:00.494077	1
1923452461	6	2019-09-25 10:53:03.436719	64
1923452463	6	2019-09-25 10:53:55.839722	1
1923452459	5	2019-09-25 10:57:33.858864	67
1923452464	1	2019-09-25 11:02:47.200612	95
1923452464	2	2019-09-25 11:03:26.164857	95
1923452464	5	2019-09-25 11:03:56.190635	95
1923452425	2	2019-09-25 11:07:03.093212	1
1923452425	5	2019-09-25 11:08:15.011564	1
1923452465	1	2019-09-25 11:08:25.994701	95
1923452408	2	2019-09-25 11:08:54.986404	95
1923452465	2	2019-09-25 11:09:55.163754	95
1923452466	1	2019-09-25 11:13:37.132532	66
1923452467	1	2019-09-25 11:14:07.879884	98
1923452468	1	2019-09-25 11:14:59.203537	40
1923452469	1	2019-09-25 11:15:42.100077	1
1923452467	2	2019-09-25 11:18:23.958394	95
1923452468	2	2019-09-25 11:20:39.120404	64
1923452468	2	2019-09-25 11:20:39.121676	64
1923452469	2	2019-09-25 11:20:57.899817	1
1923452466	2	2019-09-25 11:21:01.099996	19
1923452410	5	2019-09-25 11:21:23.89992	64
1923452410	5	2019-09-25 11:21:23.900579	64
1923452469	5	2019-09-25 11:21:53.349116	1
1923452470	1	2019-09-25 11:21:57.771929	66
1923452467	5	2019-09-25 11:22:42.852453	95
1923452470	2	2019-09-25 11:23:03.049806	19
1923452470	5	2019-09-25 11:24:17.415916	19
1923452470	4	2019-09-25 11:24:40.915059	1
1923452468	5	2019-09-25 11:24:52.091746	64
1923452468	4	2019-09-25 11:24:58.346447	95
1923452469	4	2019-09-25 11:26:48.755922	64
1923452468	6	2019-09-25 11:29:38.522227	95
1923452469	6	2019-09-25 11:29:43.080549	64
1923452466	5	2019-09-25 11:29:57.066329	19
1923452470	6	2019-09-25 11:32:59.851949	1
1923452471	1	2019-09-25 11:34:08.486025	39
1923452472	1	2019-09-25 11:34:36.814036	66
1923452473	1	2019-09-25 11:34:51.131227	94
1923452471	2	2019-09-25 11:35:04.238845	64
1923452474	1	2019-09-25 11:35:33.255112	1
1923452471	5	2019-09-25 11:35:52.886183	64
1923452472	2	2019-09-25 11:36:13.688852	19
1923452473	2	2019-09-25 11:36:19.886211	95
1923452474	2	2019-09-25 11:36:36.792175	1
1923452472	5	2019-09-25 11:37:13.322703	19
1923452474	5	2019-09-25 11:37:18.059437	1
1923452473	5	2019-09-25 11:37:21.022794	95
1923452474	4	2019-09-25 11:37:39.850091	64
1923452472	4	2019-09-25 11:37:49.602736	1
1923452471	4	2019-09-25 11:37:59.128353	95
1923452473	4	2019-09-25 11:38:00.042426	19
1923452471	6	2019-09-25 11:38:16.456577	95
1923452474	6	2019-09-25 11:38:19.434368	64
1923452472	6	2019-09-25 11:38:20.337406	1
1923452473	6	2019-09-25 11:38:39.12618	19
1923452430	2	2019-09-25 11:46:13.377616	1
1923452475	1	2019-09-25 12:17:26.774695	98
1923452475	2	2019-09-25 12:18:35.795598	95
1923452475	6	2019-09-25 12:20:28.210452	95
1923452476	1	2019-09-25 12:23:35.252913	59
1923452476	2	2019-09-25 12:24:46.612583	64
1923452476	5	2019-09-25 12:25:31.749329	64
1923452477	1	2019-09-25 12:33:01.632146	42
1923452415	2	2019-09-25 12:33:20.368295	1
1923452430	5	2019-09-25 12:33:31.776739	1
1923452415	5	2019-09-25 12:33:35.19601	1
1923452477	2	2019-09-25 12:34:12.214218	64
1923452477	5	2019-09-25 12:34:58.748782	64
1923452465	6	2019-09-25 12:37:14.921547	95
1923452408	6	2019-09-25 12:37:19.233465	95
1923452409	2	2019-09-25 12:37:43.285339	95
1923452409	6	2019-09-25 12:38:21.006081	95
1923452443	2	2019-09-25 12:38:38.124967	95
1923452443	6	2019-09-25 12:39:08.500279	95
1923452478	1	2019-09-25 12:43:42.145956	94
1923452478	2	2019-09-25 12:44:33.632362	95
1923452478	6	2019-09-25 12:44:54.511537	95
1923452479	1	2019-09-25 12:51:41.220843	94
1923452479	2	2019-09-25 12:54:11.833212	95
1923452479	5	2019-09-25 12:54:59.509643	95
1923452480	1	2019-09-25 13:39:26.21684	60
1923452446	2	2019-09-25 13:39:54.098957	1
1923452446	6	2019-09-25 13:41:56.273802	1
1923452480	2	2019-09-25 13:42:38.702406	64
1923452480	5	2019-09-25 13:42:49.229258	64
1923452416	2	2019-09-25 13:44:25.799985	1
1923452432	2	2019-09-25 13:44:31.884333	1
1923452441	2	2019-09-25 13:44:35.857361	1
1923452452	2	2019-09-25 13:44:40.58056	1
1923452441	6	2019-09-25 13:45:21.719557	1
1923452432	5	2019-09-25 13:45:30.74063	1
1923452452	5	2019-09-25 13:45:34.143637	1
1923452416	5	2019-09-25 13:45:38.032134	1
1923452426	2	2019-09-25 13:48:18.616625	67
1923452414	2	2019-09-25 13:48:26.922321	67
1923452406	5	2019-09-25 13:48:43.724552	67
1923452426	5	2019-09-25 13:48:47.369432	67
1923452414	5	2019-09-25 13:48:56.108292	67
1923452421	5	2019-09-25 13:49:03.877164	67
1923452422	6	2019-09-25 13:49:11.38116	67
1923452402	6	2019-09-25 13:49:14.496415	67
1923452445	2	2019-09-25 14:04:40.978522	67
1923452481	1	2019-09-25 14:46:25.511713	95
1923452482	1	2019-09-25 14:47:10.088265	39
1923452483	1	2019-09-25 14:47:36.288294	21
1923452484	1	2019-09-25 14:47:50.690731	105
1923452483	2	2019-09-25 14:49:10.16411	20
1923452481	2	2019-09-25 14:49:15.287845	95
1923452482	2	2019-09-25 14:50:04.971434	64
1923452481	6	2019-09-25 14:56:54.804481	95
1923452482	6	2019-09-25 14:58:25.482028	64
1923452483	6	2019-09-25 15:00:45.908875	20
1923452485	1	2019-09-25 15:03:22.414694	38
1923452486	1	2019-09-25 15:04:34.934408	95
1923452487	1	2019-09-25 15:05:16.910736	21
1923452487	2	2019-09-25 15:06:15.694275	20
1923452487	5	2019-09-25 15:07:00.153146	20
1923452485	2	2019-09-25 15:07:31.579768	64
1923452485	5	2019-09-25 15:09:19.230007	64
1923452486	2	2019-09-25 15:09:31.05885	95
1923452485	4	2019-09-25 15:10:15.88683	95
1923452486	5	2019-09-25 15:10:33.895123	95
1923452486	4	2019-09-25 15:10:40.183268	20
1923452487	4	2019-09-25 15:10:42.98437	64
1923452485	6	2019-09-25 15:11:54.621341	95
1923452486	6	2019-09-25 15:11:58.042676	20
1923452487	6	2019-09-25 15:11:58.410953	64
1923452488	1	2019-09-25 15:19:14.557275	65
1923452489	1	2019-09-25 15:21:18.690447	94
1923452490	1	2019-09-25 15:23:18.441251	82
1923452491	1	2019-09-25 15:23:37.981401	4
1923452492	1	2019-09-25 15:23:49.592641	37
1923452493	1	2019-09-25 15:23:51.085691	37
1923452489	2	2019-09-25 15:30:43.639852	95
1923452491	2	2019-09-25 15:30:45.868113	1
1923452492	2	2019-09-25 15:31:28.989196	64
1923452493	2	2019-09-25 15:31:40.492687	64
1923452490	2	2019-09-25 15:31:41.450712	67
1923452488	2	2019-09-25 15:31:48.233546	64
1923452491	5	2019-09-25 15:32:29.749512	1
1923452490	5	2019-09-25 15:33:29.10019	67
1923452491	4	2019-09-25 15:34:03.559321	95
1923452492	5	2019-09-25 15:34:04.60906	64
1923452489	5	2019-09-25 15:34:13.688368	95
1923452488	5	2019-09-25 15:34:13.878003	64
1923452493	5	2019-09-25 15:34:21.464479	64
1923452489	4	2019-09-25 15:34:23.402429	1
1923452492	4	2019-09-25 15:35:02.399649	67
1923452490	4	2019-09-25 15:35:18.706679	64
1923452493	4	2019-09-25 15:36:03.731913	67
1923452488	4	2019-09-25 15:36:13.499245	67
1923452490	6	2019-09-25 15:36:59.309595	64
1923452491	6	2019-09-25 15:37:07.227684	95
1923452489	6	2019-09-25 15:37:19.4076	1
1923452492	6	2019-09-25 15:37:53.720731	67
1923452493	6	2019-09-25 15:37:57.832808	67
1923452445	6	2019-09-25 15:38:06.320976	67
1923452494	1	2019-09-25 15:47:19.067619	96
1923452495	1	2019-09-25 15:47:24.270429	1
1923452494	2	2019-09-25 15:47:49.880909	95
1923452495	2	2019-09-25 15:48:14.40588	1
1923452495	5	2019-09-25 15:48:33.17103	1
1923452495	4	2019-09-25 15:48:38.913862	95
1923452494	5	2019-09-25 15:48:58.035057	95
1923452496	1	2019-09-25 15:50:23.968486	65
1923452496	2	2019-09-25 15:51:23.676187	64
1923452496	5	2019-09-25 15:51:47.584073	64
1923452497	1	2019-09-25 15:51:57.272331	96
1923452497	2	2019-09-25 15:52:16.185197	95
1923452497	5	2019-09-25 15:53:34.51709	95
1923452494	4	2019-09-25 15:55:12.632955	1
1923452494	6	2019-09-25 15:55:57.108459	1
1923452495	6	2019-09-25 15:56:05.944598	95
1923452498	1	2019-09-25 15:56:28.491001	82
1923452498	2	2019-09-25 15:57:42.585767	67
1923452498	5	2019-09-25 15:57:59.85867	67
1923452498	4	2019-09-25 15:58:08.249551	64
1923452496	4	2019-09-25 15:58:23.7303	67
1923452496	6	2019-09-25 15:58:50.116219	67
1923452498	6	2019-09-25 15:59:33.270483	64
1923452499	1	2019-09-25 16:01:55.352664	82
1923452500	1	2019-09-25 16:05:30.080639	94
1923452501	1	2019-09-25 16:06:04.828766	37
1923452502	1	2019-09-25 16:06:23.311965	94
1923452503	1	2019-09-25 16:06:32.083967	3
1923452504	1	2019-09-25 16:06:34.70157	94
1923452505	1	2019-09-25 16:06:38.145748	72
1923452506	1	2019-09-25 16:06:40.933309	72
1923452507	1	2019-09-25 16:06:45.174321	37
1923452500	2	2019-09-25 16:07:14.132723	95
1923452508	1	2019-09-25 16:07:16.327479	37
1923452502	2	2019-09-25 16:07:22.277414	95
1923452504	2	2019-09-25 16:07:28.716313	95
1923452501	2	2019-09-25 16:08:07.003807	64
1923452508	2	2019-09-25 16:08:12.606225	64
1923452507	2	2019-09-25 16:08:16.897083	64
1923452503	2	2019-09-25 16:08:21.959852	1
1923452509	1	2019-09-25 16:09:59.678262	3
1923452501	5	2019-09-25 16:10:03.416307	64
1923452507	5	2019-09-25 16:10:08.067161	64
1923452508	5	2019-09-25 16:10:12.399806	64
1923452507	4	2019-09-25 16:10:15.07639	95
1923452500	5	2019-09-25 16:10:23.540197	95
1923452509	2	2019-09-25 16:10:40.569718	1
1923452500	4	2019-09-25 16:10:41.621715	64
1923452509	5	2019-09-25 16:10:53.183537	1
1923452503	5	2019-09-25 16:10:57.744553	1
1923452510	1	2019-09-25 16:11:10.071552	72
1923452503	4	2019-09-25 16:11:13.242186	95
1923452502	5	2019-09-25 16:11:19.18704	95
1923452511	1	2019-09-25 16:11:22.664059	73
1923452503	6	2019-09-25 16:11:40.707187	95
1923452507	6	2019-09-25 16:11:44.555064	95
1923452512	1	2019-09-25 16:12:42.703642	3
1923452512	2	2019-09-25 16:13:09.591243	1
1923452512	5	2019-09-25 16:13:26.918757	1
1923452512	4	2019-09-25 16:13:32.644434	64
1923452508	4	2019-09-25 16:14:03.251106	1
1923452502	4	2019-09-25 16:14:15.134146	1
1923452502	6	2019-09-25 16:16:24.583668	1
1923452508	6	2019-09-25 16:16:36.882728	1
1923452499	2	2019-09-25 16:17:30.563737	67
1923452505	2	2019-09-25 16:17:39.837599	67
1923452506	2	2019-09-25 16:18:02.811176	67
1923452510	2	2019-09-25 16:18:11.871084	67
1923452511	2	2019-09-25 16:18:20.816178	67
1923452499	5	2019-09-25 16:19:24.010344	67
1923452499	4	2019-09-25 16:19:30.630156	64
1923452505	5	2019-09-25 16:20:20.755103	67
1923452505	4	2019-09-25 16:20:24.032609	95
1923452504	5	2019-09-25 16:20:37.750445	95
1923452511	5	2019-09-25 16:21:38.668994	67
1923452511	4	2019-09-25 16:21:43.643067	1
1923452505	6	2019-09-25 16:21:54.211812	95
1923452501	4	2019-09-25 16:22:04.618257	67
1923452511	6	2019-09-25 16:23:18.773168	1
1923452504	4	2019-09-25 16:23:50.967053	67
1923452510	5	2019-09-25 16:24:55.199668	67
1923452512	6	2019-09-25 16:28:02.448915	64
1923452500	6	2019-09-25 16:28:06.909325	64
1923452499	6	2019-09-25 16:28:11.493318	64
1923452504	6	2019-09-25 16:29:04.95572	67
1923452501	6	2019-09-25 16:29:14.794113	67
1923452509	4	2019-09-25 16:32:47.851854	64
1923452513	1	2019-09-25 16:41:16.34354	94
1923452514	1	2019-09-25 16:41:26.723819	4
1923452515	1	2019-09-25 16:41:31.124781	94
1923452513	2	2019-09-25 16:41:53.303747	95
1923452515	2	2019-09-25 16:42:02.561518	95
1923452514	2	2019-09-25 16:42:03.71557	1
1923452514	5	2019-09-25 16:42:22.750261	1
1923452514	4	2019-09-25 16:44:39.93598	95
1923452516	1	2019-09-25 16:44:50.152465	115
1923452517	1	2019-09-25 16:44:50.369424	57
1923452513	5	2019-09-25 16:44:55.667665	95
1923452518	1	2019-09-25 16:45:11.491544	67
1923452516	2	2019-09-25 16:45:17.326423	1
1923452517	2	2019-09-25 16:45:22.104092	64
1923452516	5	2019-09-25 16:45:33.912647	1
1923452516	4	2019-09-25 16:45:39.183551	95
1923452515	5	2019-09-25 16:45:45.382512	95
1923452517	5	2019-09-25 16:46:02.067392	64
1923452513	4	2019-09-25 16:46:07.391546	1
1923452515	4	2019-09-25 16:46:39.855564	1
1923452514	6	2019-09-25 16:46:44.591201	95
1923452516	6	2019-09-25 16:46:50.547118	95
1923452519	1	2019-09-25 16:47:07.623494	68
1923452513	6	2019-09-25 16:47:54.185926	1
1923452515	6	2019-09-25 16:48:00.788943	1
1923452518	2	2019-09-25 16:48:44.029873	67
1923452519	2	2019-09-25 16:48:57.798474	67
1923452518	5	2019-09-25 16:50:12.806926	67
1923452518	4	2019-09-25 16:50:14.827577	64
1923452519	5	2019-09-25 16:50:36.48325	67
1923452519	4	2019-09-25 16:50:39.104309	64
1923452517	4	2019-09-25 16:51:34.309107	67
1923452518	6	2019-09-25 16:51:34.713097	64
1923452519	6	2019-09-25 16:51:40.396865	64
1923452520	1	2019-09-25 17:02:18.46776	2
1923452521	1	2019-09-25 17:04:34.195954	68
1923452522	1	2019-09-25 17:07:30.896624	39
1923452523	1	2019-09-25 17:12:49.028943	94
1923452522	2	2019-09-25 17:13:05.4333	64
1923452523	2	2019-09-25 17:13:39.00924	95
1923452522	5	2019-09-25 17:13:48.720167	64
1923452521	2	2019-09-25 17:14:20.100152	67
1923452520	2	2019-09-25 17:14:34.488043	1
1923452522	4	2019-09-25 17:14:34.92376	95
1923452520	5	2019-09-25 17:15:10.079032	1
1923452521	5	2019-09-25 17:15:49.42209	67
1923452521	4	2019-09-25 17:15:56.160476	95
1923452522	6	2019-09-25 17:16:02.772711	95
1923452521	6	2019-09-25 17:16:07.013971	95
1923452520	4	2019-09-25 17:16:09.199966	67
1923452520	6	2019-09-25 17:17:06.068063	67
1923452523	5	2019-09-25 17:17:43.142388	95
1923452523	4	2019-09-25 17:17:43.297573	64
1923452523	6	2019-09-25 17:18:00.422068	64
1923452517	6	2019-09-25 17:18:26.209855	67
1923452524	1	2019-09-26 14:17:53.932392	67
1923452525	1	2019-09-26 14:18:26.23454	48
1923452525	2	2019-09-26 14:26:13.157749	64
1923452526	1	2019-09-26 14:26:29.632676	95
1923452525	5	2019-09-26 14:28:58.353353	64
1923452526	2	2019-09-26 14:30:03.217315	95
1923452526	7	2019-09-26 14:31:20.660358	95
1923452526	6	2019-09-26 14:31:40.396672	95
1923452527	1	2019-09-26 14:42:00.034782	71
1923452527	2	2019-09-26 14:43:32.265924	67
1923452528	1	2019-09-26 14:59:17.850999	69
1923452528	2	2019-09-26 15:03:46.46849	67
1923452528	5	2019-09-26 15:07:20.510804	67
1923452527	5	2019-09-26 15:08:20.580361	67
1923452528	4	2019-09-26 15:10:27.970518	67
1923452528	5	2019-09-26 15:11:09.143441	67
1923452529	1	2019-09-26 15:21:26.061345	1
1923452529	2	2019-09-26 15:25:53.618034	1
1923452529	5	2019-09-26 15:27:11.299681	1
1923452449	7	2019-09-26 15:51:48.449569	19
1923452524	2	2019-09-26 16:04:09.088462	67
1923452530	1	2019-09-26 16:05:56.448487	22
1923452524	5	2019-09-26 16:14:21.064738	67
1923452530	2	2019-09-26 16:18:38.201656	20
1923452392	5	2019-09-26 16:20:45.078517	20
1923452530	5	2019-09-26 16:22:37.985456	20
1923452427	5	2019-09-26 16:23:15.698539	20
1923452530	4	2019-09-26 16:24:55.519157	19
1923452530	6	2019-09-26 16:25:56.967032	19
1923452531	1	2019-09-26 17:18:27.661817	1
1923452531	2	2019-09-26 17:28:39.750943	1
1923452531	6	2019-09-26 17:37:00.883558	1
1923452449	6	2019-09-27 10:28:37.369101	19
1923452532	1	2019-09-27 10:54:19.28369	66
1923452533	1	2019-09-27 10:55:26.842674	94
1923452534	1	2019-09-27 10:55:27.913564	5
1923452535	1	2019-09-27 10:55:35.737661	5
1923452536	1	2019-09-27 10:56:00.429458	65
1923452536	2	2019-09-27 10:56:43.798944	64
1923452533	2	2019-09-27 10:56:55.231123	95
1923452532	2	2019-09-27 10:57:37.528473	19
1923452537	1	2019-09-27 10:58:02.198629	5
1923452533	6	2019-09-27 10:58:14.872007	95
1923452534	2	2019-09-27 10:58:43.474378	1
1923452536	6	2019-09-27 10:59:32.471245	64
1923452532	6	2019-09-27 10:59:46.940529	19
1923452534	6	2019-09-27 10:59:47.864694	1
1923452535	2	2019-09-27 11:01:32.717992	1
1923452537	2	2019-09-27 11:01:48.986175	1
1923452535	6	2019-09-27 11:02:55.636431	1
1923452537	6	2019-09-27 11:03:00.207564	1
1923452538	1	2019-09-27 11:08:25.299241	57
1923452539	1	2019-09-27 11:08:34.565376	94
1923452540	1	2019-09-27 11:08:52.056713	7
1923452538	2	2019-09-27 11:09:04.558991	64
1923452539	2	2019-09-27 11:09:14.64613	95
1923452539	5	2019-09-27 11:09:57.716401	95
1923452538	5	2019-09-27 11:10:12.998516	64
1923452540	2	2019-09-27 11:10:18.357667	1
1923452541	1	2019-09-27 11:10:32.845725	66
1923452538	4	2019-09-27 11:10:44.581183	95
1923452539	4	2019-09-27 11:10:46.487817	64
1923452541	2	2019-09-27 11:11:03.994485	19
1923452539	6	2019-09-27 11:11:13.487623	64
1923452538	6	2019-09-27 11:11:29.754168	95
1923452540	5	2019-09-27 11:11:45.863823	1
1923452541	5	2019-09-27 11:12:02.174774	19
1923452541	4	2019-09-27 11:12:22.716497	1
1923452541	6	2019-09-27 11:14:59.901693	1
1923452542	1	2019-09-27 11:15:27.478931	21
1923452540	4	2019-09-27 11:16:44.968599	19
1923452540	6	2019-09-27 11:16:54.312286	19
1923452542	2	2019-09-27 11:17:51.697481	20
1923452543	1	2019-09-27 11:19:49.16569	94
1923452544	1	2019-09-27 11:20:17.316139	59
1923452542	6	2019-09-27 11:20:20.450817	20
1923452543	2	2019-09-27 11:20:28.842389	95
1923452545	1	2019-09-27 11:20:37.673658	66
1923452544	2	2019-09-27 11:20:42.459511	64
1923452546	1	2019-09-27 11:20:45.201506	7
1923452543	5	2019-09-27 11:20:55.074488	95
1923452545	2	2019-09-27 11:21:09.849114	19
1923452544	5	2019-09-27 11:21:14.244917	64
1923452546	2	2019-09-27 11:21:28.375771	1
1923452545	5	2019-09-27 11:21:50.98255	19
1923452545	4	2019-09-27 11:21:52.934054	64
1923452544	4	2019-09-27 11:22:14.703917	19
1923452543	4	2019-09-27 11:22:16.73955	95
1923452546	5	2019-09-27 11:22:28.05369	1
1923452544	6	2019-09-27 11:22:28.746858	19
1923452546	4	2019-09-27 11:22:34.198339	95
1923452543	5	2019-09-27 11:23:20.274236	95
1923452543	4	2019-09-27 11:23:24.081765	1
1923452545	5	2019-09-27 11:23:40.654482	64
1923452543	6	2019-09-27 11:23:48.056023	1
1923452545	4	2019-09-27 11:24:03.081075	95
1923452546	5	2019-09-27 11:24:38.723512	95
1923452546	4	2019-09-27 11:24:45.020553	64
1923452546	6	2019-09-27 11:25:00.507384	64
1923452545	6	2019-09-27 11:25:18.649295	95
1923452547	1	2019-09-27 11:30:41.042225	94
1923452548	1	2019-09-27 11:30:50.901432	6
1923452549	1	2019-09-27 11:30:51.367118	94
1923452550	1	2019-09-27 11:30:54.550184	59
1923452549	2	2019-09-27 11:31:07.697879	95
1923452547	2	2019-09-27 11:31:13.282442	95
1923452548	2	2019-09-27 11:31:13.424616	1
1923452549	5	2019-09-27 11:31:33.919767	95
1923452547	5	2019-09-27 11:31:37.006293	95
1923452551	1	2019-09-27 11:31:38.00465	65
1923452548	5	2019-09-27 11:31:42.026756	1
1923452551	2	2019-09-27 11:32:14.457027	64
1923452550	2	2019-09-27 11:32:28.220879	64
1923452552	1	2019-09-27 11:32:51.762712	6
1923452552	2	2019-09-27 11:33:17.104512	1
1923452553	1	2019-09-27 11:33:18.812696	66
1923452554	1	2019-09-27 11:33:27.699246	66
1923452550	5	2019-09-27 11:33:28.991593	64
1923452551	5	2019-09-27 11:33:33.5935	64
1923452554	2	2019-09-27 11:33:40.406523	19
1923452552	5	2019-09-27 11:33:43.105396	1
1923452550	4	2019-09-27 11:33:46.945725	95
1923452553	2	2019-09-27 11:33:48.193111	19
1923452550	6	2019-09-27 11:33:57.467816	95
1923452548	4	2019-09-27 11:34:06.725241	64
1923452554	5	2019-09-27 11:34:24.244818	19
1923452553	5	2019-09-27 11:34:31.370728	19
1923452552	4	2019-09-27 11:34:40.90481	95
1923452552	6	2019-09-27 11:34:47.047748	95
1923452548	6	2019-09-27 11:34:55.345673	64
1923452547	4	2019-09-27 11:35:24.677913	19
1923452553	4	2019-09-27 11:35:50.073685	1
1923452553	5	2019-09-27 11:36:45.492224	1
1923452547	7	2019-09-27 11:36:49.157227	19
1923452411	5	2019-09-27 11:38:06.178979	20
1923452547	6	2019-09-27 11:40:11.233455	19
1923452555	1	2019-09-27 11:43:57.294488	20
1923452556	1	2019-09-27 11:51:22.7983	6
1923452557	1	2019-09-27 11:51:59.077409	37
1923452558	1	2019-09-27 11:52:13.678039	46
1923452557	2	2019-09-27 11:52:28.853164	64
1923452559	1	2019-09-27 11:52:32.464371	94
1923452556	2	2019-09-27 11:52:35.370518	1
1923452560	1	2019-09-27 11:52:36.694807	66
1923452558	2	2019-09-27 11:52:38.169782	64
1923452555	2	2019-09-27 11:52:42.665413	20
1923452561	1	2019-09-27 11:52:45.812112	94
1923452556	5	2019-09-27 11:53:01.980071	1
1923452559	2	2019-09-27 11:53:15.735333	95
1923452561	2	2019-09-27 11:53:34.55754	95
1923452561	2	2019-09-27 11:53:34.55895	95
1923452555	5	2019-09-27 11:53:54.255248	20
1923452559	5	2019-09-27 11:53:55.076246	95
1923452557	5	2019-09-27 11:53:55.479717	64
1923452558	5	2019-09-27 11:53:58.700531	64
1923452561	5	2019-09-27 11:54:18.671095	95
1923452562	1	2019-09-27 11:54:21.674531	6
1923452561	4	2019-09-27 11:54:23.239813	64
1923452563	1	2019-09-27 11:54:28.115931	66
1923452558	4	2019-09-27 11:54:34.348553	95
1923452561	6	2019-09-27 11:54:36.263872	64
1923452564	1	2019-09-27 11:54:36.642221	66
1923452562	2	2019-09-27 11:54:48.579071	1
1923452558	6	2019-09-27 11:55:12.28539	95
1923452556	4	2019-09-27 11:55:59.363996	64
1923452556	6	2019-09-27 11:56:11.284304	64
1923452560	2	2019-09-27 11:56:31.995886	19
1923452563	2	2019-09-27 11:56:39.162464	19
1923452563	5	2019-09-27 11:56:49.910012	19
1923452560	5	2019-09-27 11:56:55.321022	19
1923452560	4	2019-09-27 11:56:55.640227	95
1923452560	6	2019-09-27 11:57:02.700467	95
1923452565	1	2019-09-27 11:57:23.964122	1
1923452565	2	2019-09-27 11:57:53.478622	1
1923452559	4	2019-09-27 11:59:17.741408	19
1923452555	4	2019-09-27 11:59:19.078981	1
1923452559	6	2019-09-27 11:59:34.030395	19
1923452559	6	2019-09-27 11:59:34.031157	19
1923452562	5	2019-09-27 11:59:57.882219	1
1923452555	6	2019-09-27 12:00:21.429629	1
1923452557	4	2019-09-27 12:00:28.381119	19
1923452557	6	2019-09-27 12:00:36.221925	19
1923452565	5	2019-09-27 12:00:44.637615	1
1923452566	1	2019-09-27 12:05:27.670898	1
1923452567	1	2019-09-27 12:05:34.103254	37
1923452566	2	2019-09-27 12:06:05.319854	1
1923452566	5	2019-09-27 12:06:22.171748	1
1923452568	1	2019-09-27 12:06:35.96466	65
1923452569	1	2019-09-27 12:06:37.07266	66
1923452570	1	2019-09-27 12:06:45.872198	94
1923452567	2	2019-09-27 12:06:45.989188	64
1923452568	2	2019-09-27 12:06:50.769046	64
1923452570	2	2019-09-27 12:07:02.49083	95
1923452571	1	2019-09-27 12:07:22.718728	66
1923452568	5	2019-09-27 12:07:23.06954	64
1923452570	5	2019-09-27 12:07:23.687236	95
1923452567	5	2019-09-27 12:07:42.866928	64
1923452572	1	2019-09-27 12:07:50.029996	94
1923452573	1	2019-09-27 12:08:02.626335	20
1923452574	1	2019-09-27 12:08:06.444339	20
1923452575	1	2019-09-27 12:08:20.946742	1
1923452572	2	2019-09-27 12:08:23.58253	95
1923452568	4	2019-09-27 12:08:28.821656	20
1923452569	2	2019-09-27 12:08:29.504443	19
1923452571	2	2019-09-27 12:08:38.098832	19
1923452575	2	2019-09-27 12:08:41.394506	1
1923452567	4	2019-09-27 12:08:53.064604	95
1923452575	5	2019-09-27 12:09:06.700266	1
1923452564	2	2019-09-27 12:09:15.290189	19
1923452564	2	2019-09-27 12:09:15.29349	19
1923452572	5	2019-09-27 12:09:33.074359	95
1923452567	6	2019-09-27 12:09:58.286315	95
1923452566	4	2019-09-27 12:10:15.815354	64
1923452568	6	2019-09-27 12:10:21.764506	20
1923452566	6	2019-09-27 12:10:27.196398	64
1923452569	5	2019-09-27 12:10:35.530147	19
1923452564	5	2019-09-27 12:10:38.922105	19
1923452576	1	2019-09-27 12:10:41.064444	21
1923452571	5	2019-09-27 12:10:42.548794	19
1923452570	4	2019-09-27 12:11:04.605367	19
1923452573	2	2019-09-27 12:11:08.638425	20
1923452564	4	2019-09-27 12:11:27.007179	1
1923452575	4	2019-09-27 12:11:31.67089	19
1923452574	2	2019-09-27 12:11:33.753154	20
1923452570	6	2019-09-27 12:11:38.922842	19
1923452575	6	2019-09-27 12:11:49.226127	19
1923452573	5	2019-09-27 12:12:12.144264	20
1923452564	6	2019-09-27 12:12:17.867872	1
1923452574	5	2019-09-27 12:12:43.572007	20
1923452573	4	2019-09-27 12:13:00.982029	1
1923452576	2	2019-09-27 12:13:07.104113	20
1923452573	6	2019-09-27 12:13:08.995057	1
1923452576	5	2019-09-27 12:13:44.040597	20
1923452576	4	2019-09-27 12:13:47.187995	64
1923452576	6	2019-09-27 12:13:52.64157	64
1923452572	4	2019-09-27 12:16:21.341847	20
1923452572	6	2019-09-27 12:17:05.375226	20
1923452412	2	2019-09-27 14:09:54.863765	20
1923452418	2	2019-09-27 14:10:05.944187	20
1923452417	2	2019-09-27 14:10:16.736517	20
1923452577	1	2019-09-27 14:12:23.815725	37
1923452578	1	2019-09-27 14:12:23.956189	3
1923452579	1	2019-09-27 14:12:31.183593	94
1923452580	1	2019-09-27 14:12:39.247057	94
1923452581	1	2019-09-27 14:12:53.491904	66
1923452577	2	2019-09-27 14:12:54.158167	64
1923452578	2	2019-09-27 14:13:01.232178	1
1923452582	1	2019-09-27 14:13:01.913939	46
1923452583	1	2019-09-27 14:13:21.805224	94
1923452577	5	2019-09-27 14:13:36.11067	64
1923452583	2	2019-09-27 14:13:44.178738	95
1923452579	2	2019-09-27 14:13:44.183383	95
1923452580	2	2019-09-27 14:13:44.184351	95
1923452584	1	2019-09-27 14:13:44.389354	20
1923452582	2	2019-09-27 14:13:46.223558	64
1923452585	1	2019-09-27 14:13:48.007863	66
1923452586	1	2019-09-27 14:13:53.981482	20
1923452587	1	2019-09-27 14:14:03.773777	3
1923452588	1	2019-09-27 14:14:07.191893	66
1923452589	1	2019-09-27 14:14:21.599034	20
1923452583	5	2019-09-27 14:14:29.901503	95
1923452584	2	2019-09-27 14:14:42.010922	20
1923452587	2	2019-09-27 14:14:44.718448	1
1923452580	5	2019-09-27 14:14:49.567305	95
1923452586	2	2019-09-27 14:14:50.431861	20
1923452579	5	2019-09-27 14:14:57.061955	95
1923452589	2	2019-09-27 14:14:58.222041	20
1923452581	2	2019-09-27 14:15:02.745899	19
1923452585	2	2019-09-27 14:15:08.129837	19
1923452582	5	2019-09-27 14:15:09.457376	64
1923452588	2	2019-09-27 14:15:15.643758	19
1923452577	4	2019-09-27 14:15:47.151801	95
1923452587	5	2019-09-27 14:16:02.432591	1
1923452578	5	2019-09-27 14:16:06.781912	1
1923452578	4	2019-09-27 14:16:15.462231	95
1923452590	1	2019-09-27 14:17:29.37671	3
1923452586	5	2019-09-27 14:17:50.838274	20
1923452585	5	2019-09-27 14:18:09.68125	19
1923452588	5	2019-09-27 14:18:13.515753	19
1923452581	5	2019-09-27 14:18:16.763041	19
1923452591	1	2019-09-27 14:18:29.608057	37
1923452590	2	2019-09-27 14:18:52.832697	1
1923452590	5	2019-09-27 14:19:04.638597	1
1923452581	4	2019-09-27 14:22:09.835563	95
1923452589	5	2019-09-27 14:22:41.373775	20
1923452591	2	2019-09-27 14:22:46.708729	64
1923452584	5	2019-09-27 14:22:48.823978	20
1923452581	6	2019-09-27 14:22:49.859093	95
1923452586	4	2019-09-27 14:22:54.828229	1
1923452578	6	2019-09-27 14:22:56.723994	95
1923452583	4	2019-09-27 14:23:00.798078	19
1923452577	6	2019-09-27 14:23:01.872565	95
1923452586	6	2019-09-27 14:23:19.531668	1
1923452583	6	2019-09-27 14:23:20.719214	19
1923452591	5	2019-09-27 14:23:35.611002	64
1923452582	4	2019-09-27 14:23:43.135461	1
1923452582	6	2019-09-27 14:24:03.338651	1
1923452584	4	2019-09-27 14:24:05.959638	95
1923452587	4	2019-09-27 14:24:25.786287	20
1923452584	6	2019-09-27 14:24:31.673012	95
1923452592	1	2019-09-27 14:24:43.1547	37
1923452580	4	2019-09-27 14:24:48.348722	1
1923452580	6	2019-09-27 14:25:03.658668	1
1923452585	4	2019-09-27 14:25:55.387759	20
1923452589	4	2019-09-27 14:26:28.188697	64
1923452589	6	2019-09-27 14:26:34.637722	64
1923452592	2	2019-09-27 14:26:55.930039	64
1923452592	5	2019-09-27 14:27:08.426492	64
1923452592	4	2019-09-27 14:27:09.690642	20
1923452587	6	2019-09-27 14:27:20.01434	20
1923452585	6	2019-09-27 14:27:24.830339	20
1923452592	6	2019-09-27 14:27:30.224817	20
1923452579	4	2019-09-27 14:27:54.565183	64
1923452579	6	2019-09-27 14:28:14.833249	64
1923452593	1	2019-09-27 14:40:45.144174	6
1923452594	1	2019-09-27 14:40:58.727908	94
1923452595	1	2019-09-27 14:41:00.893276	66
1923452596	1	2019-09-27 14:41:04.80872	46
1923452597	1	2019-09-27 14:41:07.479212	66
1923452598	1	2019-09-27 14:41:09.541522	94
1923452593	2	2019-09-27 14:41:22.738479	1
1923452599	1	2019-09-27 14:41:24.126448	20
1923452596	2	2019-09-27 14:41:24.324641	64
1923452600	1	2019-09-27 14:41:24.944827	66
1923452601	1	2019-09-27 14:41:29.068886	94
1923452602	1	2019-09-27 14:41:31.637993	94
1923452601	2	2019-09-27 14:41:38.545797	95
1923452593	5	2019-09-27 14:41:40.81967	1
1923452602	2	2019-09-27 14:41:46.848179	95
1923452595	2	2019-09-27 14:41:47.136605	19
1923452598	2	2019-09-27 14:41:51.778269	95
1923452600	2	2019-09-27 14:41:54.190009	19
1923452594	2	2019-09-27 14:41:56.54246	95
1923452597	2	2019-09-27 14:41:58.826105	19
1923452596	5	2019-09-27 14:42:04.79562	64
1923452603	1	2019-09-27 14:42:17.282601	20
1923452604	1	2019-09-27 14:42:45.14717	37
1923452605	1	2019-09-27 14:43:01.370427	6
1923452604	2	2019-09-27 14:43:14.635175	64
1923452606	1	2019-09-27 14:43:32.71104	94
1923452599	2	2019-09-27 14:43:35.659447	20
1923452607	1	2019-09-27 14:43:39.218329	37
1923452603	2	2019-09-27 14:43:43.466473	20
1923452608	1	2019-09-27 14:43:52.192161	94
1923452605	2	2019-09-27 14:43:53.343208	1
1923452604	5	2019-09-27 14:44:01.400158	64
1923452606	2	2019-09-27 14:44:15.30353	95
1923452606	5	2019-09-27 14:44:34.066408	95
1923452607	2	2019-09-27 14:44:34.093218	64
1923452595	5	2019-09-27 14:44:38.669124	19
1923452602	5	2019-09-27 14:44:41.378207	95
1923452607	5	2019-09-27 14:44:42.341598	64
1923452597	5	2019-09-27 14:44:42.816035	19
1923452601	5	2019-09-27 14:44:44.209452	95
1923452600	5	2019-09-27 14:44:46.709539	19
1923452594	5	2019-09-27 14:44:49.372195	95
1923452598	5	2019-09-27 14:44:51.54571	95
1923452609	1	2019-09-27 14:44:55.202516	6
1923452600	4	2019-09-27 14:44:55.997894	64
1923452600	6	2019-09-27 14:45:03.332582	64
1923452593	4	2019-09-27 14:45:07.616314	95
1923452609	2	2019-09-27 14:45:27.910853	1
1923452593	6	2019-09-27 14:45:34.821623	95
1923452594	4	2019-09-27 14:45:40.280208	19
1923452605	5	2019-09-27 14:45:45.421497	1
1923452609	5	2019-09-27 14:45:50.296028	1
1923452603	5	2019-09-27 14:45:53.630053	20
1923452598	4	2019-09-27 14:45:59.918503	64
1923452599	5	2019-09-27 14:46:02.085893	20
1923452598	6	2019-09-27 14:46:06.949579	64
1923452599	4	2019-09-27 14:46:23.173131	95
1923452609	4	2019-09-27 14:46:30.192769	19
1923452599	6	2019-09-27 14:46:30.341585	95
1923452603	4	2019-09-27 14:46:34.369143	64
1923452603	6	2019-09-27 14:46:40.967571	64
1923452610	1	2019-09-27 14:46:44.166922	6
1923452594	6	2019-09-27 14:46:49.64002	19
1923452609	6	2019-09-27 14:46:54.679876	19
1923452412	5	2019-09-27 14:46:57.428875	20
1923452610	2	2019-09-27 14:47:11.945649	1
1923452611	1	2019-09-27 14:47:18.086502	66
1923452610	5	2019-09-27 14:47:20.637659	1
1923452605	4	2019-09-27 14:47:24.269947	20
1923452610	4	2019-09-27 14:47:25.103657	64
1923452610	6	2019-09-27 14:47:30.298274	64
1923452596	4	2019-09-27 14:47:36.614671	1
1923452601	4	2019-09-27 14:47:43.301411	20
1923452612	1	2019-09-27 14:48:00.170284	37
1923452613	1	2019-09-27 14:48:11.149315	66
1923452605	6	2019-09-27 14:48:41.995973	20
1923452611	2	2019-09-27 14:48:46.219196	19
1923452601	6	2019-09-27 14:48:48.3337	20
1923452613	2	2019-09-27 14:48:51.951463	19
1923452608	2	2019-09-27 14:48:55.73864	95
1923452614	1	2019-09-27 14:49:20.548558	37
1923452614	2	2019-09-27 14:49:37.020308	64
1923452595	4	2019-09-27 14:52:32.861466	20
1923452595	6	2019-09-27 14:52:44.695501	20
1923452596	6	2019-09-27 14:54:25.470275	1
1923452606	4	2019-09-27 14:55:06.131801	1
1923452606	6	2019-09-27 14:56:27.338547	1
1923452613	5	2019-09-27 14:56:27.465511	19
1923452612	2	2019-09-27 14:56:28.205848	64
1923452613	4	2019-09-27 14:56:29.805199	95
1923452613	6	2019-09-27 14:56:38.747637	95
1923452611	5	2019-09-27 14:56:41.520549	19
1923452614	5	2019-09-27 14:56:44.062949	64
1923452612	5	2019-09-27 14:56:48.034126	64
1923452608	5	2019-09-27 14:56:51.414424	95
1923452611	4	2019-09-27 14:56:56.165881	1
1923452611	6	2019-09-27 14:57:06.877294	1
1923452417	5	2019-09-27 14:58:51.169499	20
1923452418	5	2019-09-27 14:58:57.502576	20
1923452615	1	2019-09-27 15:06:19.359305	94
1923452615	2	2019-09-27 15:09:52.783451	95
1923452615	5	2019-09-27 15:11:40.865492	95
1923452509	5	2019-09-27 15:23:51.080978	64
1923452616	1	2019-09-27 15:26:09.454514	95
1923452617	1	2019-09-27 15:46:21.144435	64
1923452617	2	2019-09-27 16:06:53.721425	64
1923452617	5	2019-09-27 16:07:24.692505	64
1923452484	2	2019-09-27 16:09:38.916042	107
1923452484	6	2019-09-27 16:10:15.076505	107
1923452407	6	2019-09-27 16:10:18.43217	107
1923452423	5	2019-09-27 16:10:27.954715	107
1923452618	1	2019-09-27 16:10:48.646892	1
1923452618	2	2019-09-27 16:11:33.157791	1
1923452618	5	2019-09-27 16:12:03.070508	1
1923452619	1	2019-09-27 16:12:09.790054	104
1923452619	2	2019-09-27 16:12:27.087766	107
1923452619	5	2019-09-27 16:12:59.293663	107
1923452620	1	2019-09-27 16:13:03.904792	1
1923452620	2	2019-09-27 16:13:36.749604	1
1923452620	5	2019-09-27 16:13:59.850837	1
1923452619	4	2019-09-27 16:14:23.463495	1
1923452620	4	2019-09-27 16:14:24.872167	107
1923452620	6	2019-09-27 16:14:47.091354	107
1923452619	6	2019-09-27 16:15:10.085671	1
1923452621	1	2019-09-27 16:16:51.771703	96
1923452622	1	2019-09-27 16:19:24.935588	107
1923452622	2	2019-09-27 16:19:38.424933	107
1923452622	5	2019-09-27 16:20:09.051076	107
1923452623	1	2019-09-27 16:20:31.707986	20
1923452623	2	2019-09-27 16:21:20.300241	20
1923452623	5	2019-09-27 16:23:57.53174	20
1923452623	5	2019-09-27 16:23:57.532472	20
1923452622	4	2019-09-27 16:24:12.081434	107
1923452622	5	2019-09-27 16:27:52.448341	107
1923452622	4	2019-09-27 16:30:11.323488	20
1923452623	4	2019-09-27 16:31:17.544451	107
1923452622	6	2019-09-27 16:31:34.142675	20
1923452622	6	2019-09-27 16:31:34.147877	20
1923452623	6	2019-09-27 16:31:40.970572	107
1923452623	6	2019-09-27 16:31:40.970725	107
1923452623	6	2019-09-27 16:31:40.973709	107
1923452623	6	2019-09-27 16:31:40.975934	107
1923452624	1	2019-09-27 16:43:42.262428	37
1923452621	2	2019-09-27 16:45:12.696746	95
1923452616	2	2019-09-27 16:45:30.491012	95
1923452621	5	2019-09-27 16:45:41.274605	95
1923452616	5	2019-09-27 16:45:44.0341	95
1923452624	2	2019-09-27 16:45:44.628656	64
1923452625	1	2019-09-27 16:46:52.362291	113
1923452625	2	2019-09-27 16:57:01.277609	107
1923452625	6	2019-09-27 17:03:14.138478	107
1923452624	5	2019-09-27 17:08:00.451121	64
1923452626	1	2019-09-27 17:12:22.126622	37
1923452626	2	2019-09-27 17:16:44.253836	64
1923452626	6	2019-09-27 17:24:29.077267	64
1923452627	1	2019-09-30 10:24:29.859042	1
1923452627	2	2019-09-30 10:37:23.100704	1
1923452627	6	2019-09-30 10:46:32.926189	1
1923452628	1	2019-09-30 10:57:56.614762	1
1923452629	1	2019-09-30 10:57:59.8771	1
1923452628	2	2019-09-30 11:12:15.858967	1
1923452628	5	2019-09-30 11:57:28.855706	1
1923452630	1	2019-09-30 12:02:08.284691	94
1923452631	1	2019-09-30 12:02:17.013672	94
1923452630	2	2019-09-30 12:02:46.273211	95
1923452631	2	2019-09-30 12:03:13.700081	95
1923452631	2	2019-09-30 12:03:13.70584	95
1923452630	5	2019-09-30 12:03:39.456089	95
1923452631	5	2019-09-30 12:04:00.33557	95
1923452630	4	2019-09-30 12:04:10.945869	1
1923452631	4	2019-09-30 12:05:07.971603	1
1923452630	6	2019-09-30 12:06:31.462441	1
1923452630	6	2019-09-30 12:06:31.463029	1
1923452631	6	2019-09-30 12:06:44.864738	1
1923452631	6	2019-09-30 12:06:44.866018	1
1923452631	6	2019-09-30 12:06:44.86706	1
1923452631	6	2019-09-30 12:06:44.867533	1
1923452631	6	2019-09-30 12:06:44.868119	1
1923452631	6	2019-09-30 12:06:44.870654	1
1923452632	1	2019-09-30 12:09:02.576453	1
1923452633	1	2019-09-30 12:09:20.823904	1
1923452629	2	2019-09-30 12:10:35.653186	1
1923452629	5	2019-09-30 12:11:35.670071	1
1923452629	4	2019-09-30 12:11:36.173822	95
1923452632	2	2019-09-30 12:11:57.315541	1
1923452633	2	2019-09-30 12:12:20.71076	1
1923452629	6	2019-09-30 12:12:30.582659	95
1923452632	5	2019-09-30 12:13:16.108851	1
1923452632	5	2019-09-30 12:13:16.109513	1
1923452632	5	2019-09-30 12:13:16.110858	1
1923452632	5	2019-09-30 12:13:16.111747	1
1923452632	5	2019-09-30 12:13:16.114064	1
1923452632	5	2019-09-30 12:13:16.114161	1
1923452632	5	2019-09-30 12:13:16.114451	1
1923452633	5	2019-09-30 12:13:25.318644	1
1923452632	4	2019-09-30 12:13:31.176262	95
1923452633	4	2019-09-30 12:14:08.4366	95
1923452632	6	2019-09-30 12:15:15.207476	95
1923452633	6	2019-09-30 12:15:37.757958	95
1923452634	1	2019-10-01 14:32:32.246608	95
1923452634	2	2019-10-01 14:37:02.247295	95
1923452634	6	2019-10-01 14:38:45.10652	95
1923452635	1	2019-10-01 14:43:36.107697	20
1923452635	2	2019-10-01 14:44:57.86942	20
1923452635	5	2019-10-01 14:45:07.532985	20
1923452635	4	2019-10-01 14:45:08.669789	95
1923452635	6	2019-10-01 14:49:31.005096	95
1923452636	1	2019-10-01 15:42:32.084553	66
1923452636	2	2019-10-01 15:44:03.588281	19
1923452636	6	2019-10-01 15:45:06.109886	19
1923452637	1	2019-10-05 13:39:18.483275	61
1923452637	2	2019-10-05 13:44:00.119145	64
1923452637	5	2019-10-05 13:45:49.062944	64
1923452637	4	2019-10-05 13:47:12.990758	95
1923452637	6	2019-10-05 13:49:28.559988	95
1923452638	1	2019-10-05 13:50:40.670651	95
1923452638	2	2019-10-05 13:51:42.637199	95
1923452638	6	2019-10-05 13:53:01.950014	95
1923452639	1	2019-10-07 13:52:37.076924	102
1923452640	1	2019-10-07 13:52:43.91181	3
1923452640	2	2019-10-07 13:54:54.578934	1
1923452640	5	2019-10-07 13:55:10.935642	1
1923452640	4	2019-10-07 13:57:04.925081	64
1923452640	6	2019-10-07 13:57:33.29635	64
1923452639	2	2019-10-07 14:00:49.405355	95
1923452639	5	2019-10-07 14:01:02.751761	95
1923452639	4	2019-10-07 14:01:56.247301	20
1923452639	7	2019-10-07 14:07:43.810667	20
1923452639	6	2019-10-07 14:08:23.854662	20
1923452641	1	2019-10-07 14:36:09.353269	26
1923452642	1	2019-10-07 14:36:16.609779	65
1923452643	1	2019-10-07 14:36:22.238701	68
1923452644	1	2019-10-07 14:36:27.049258	68
1923452645	1	2019-10-07 14:36:36.145059	2
1923452646	1	2019-10-07 14:36:41.51084	66
1923452647	1	2019-10-07 14:36:48.688982	1
1923452648	1	2019-10-07 14:36:57.271625	114
1923452649	1	2019-10-07 14:37:03.851493	92
1923452650	1	2019-10-07 14:37:09.451088	42
1923452651	1	2019-10-07 14:37:14.045596	20
1923452641	2	2019-10-07 14:43:08.25653	20
1923452651	2	2019-10-07 14:43:22.000741	20
1923452651	5	2019-10-07 14:45:44.138255	20
1923452641	5	2019-10-07 14:45:50.213788	20
1923452650	2	2019-10-07 14:46:48.247152	64
1923452648	2	2019-10-07 14:47:02.480794	64
1923452642	2	2019-10-07 14:47:09.150968	64
1923452648	5	2019-10-07 14:47:34.090901	64
1923452650	5	2019-10-07 14:47:39.93179	64
1923452642	5	2019-10-07 14:47:43.66864	64
1923452651	4	2019-10-07 14:48:05.358768	64
1923452643	2	2019-10-07 14:49:50.622694	67
1923452651	6	2019-10-07 14:50:09.137843	64
1923452644	2	2019-10-07 14:50:51.558161	67
1923452645	2	2019-10-07 14:51:34.208085	1
1923452647	2	2019-10-07 14:51:43.477548	1
1923452506	5	2019-10-07 14:51:49.774025	67
1923452488	5	2019-10-07 14:52:50.108477	67
1923452643	5	2019-10-07 14:53:41.221034	67
1923452644	5	2019-10-07 14:54:00.607091	67
1923452649	2	2019-10-07 14:54:24.234515	95
1923452649	5	2019-10-07 14:54:58.148264	95
1923452647	6	2019-10-07 14:57:54.1052	1
1923452645	5	2019-10-07 14:58:40.652971	1
1923452646	2	2019-10-07 14:58:45.023494	19
1923452642	4	2019-10-07 15:00:38.374484	67
1923452643	4	2019-10-07 15:01:00.441174	67
1923452645	4	2019-10-07 15:01:11.228686	67
1923452646	5	2019-10-07 15:01:33.401543	19
1923452645	6	2019-10-07 15:01:34.432559	67
1923452642	5	2019-10-07 15:01:53.693138	67
1923452643	5	2019-10-07 15:02:01.632366	67
1923452642	4	2019-10-07 15:02:31.351708	107
1923452642	6	2019-10-07 15:03:36.799004	107
1923452643	4	2019-10-07 15:06:20.019376	1
1923452643	6	2019-10-07 15:06:33.551198	1
1923452650	4	2019-10-07 15:07:10.201419	95
1923452650	6	2019-10-07 15:07:35.677667	95
1923452641	4	2019-10-07 15:07:46.463138	64
1923452641	5	2019-10-07 15:08:36.176737	64
1923452641	4	2019-10-07 15:11:33.970545	67
1923452649	4	2019-10-07 15:12:05.079971	67
1923452646	4	2019-10-07 15:12:18.961426	67
1923452649	6	2019-10-07 15:12:33.363956	67
1923452646	6	2019-10-07 15:12:44.588437	67
1923452641	6	2019-10-07 15:12:57.553294	67
1923452506	4	2019-10-07 15:13:07.10192	107
1923452506	5	2019-10-07 15:15:45.022906	107
1923452506	4	2019-10-07 15:17:37.263373	67
1923452506	5	2019-10-07 15:20:28.255298	67
1923452506	4	2019-10-07 15:21:31.775321	107
1923452506	5	2019-10-07 15:21:56.368173	107
1923452652	1	2019-10-08 10:11:36.609196	39
1923452652	2	2019-10-08 10:15:41.420963	64
1923452652	6	2019-10-08 10:25:52.579172	64
1923452653	1	2019-10-08 10:29:31.095187	4
1923452654	1	2019-10-08 10:31:37.497387	41
1923452655	1	2019-10-08 10:33:05.608521	95
1923452656	1	2019-10-08 10:34:06.902895	67
1923452657	1	2019-10-08 10:35:37.619701	67
1923452658	1	2019-10-08 10:37:44.778405	66
1923452659	1	2019-10-08 10:37:52.118703	66
1923452660	1	2019-10-08 10:37:59.256135	64
1923452661	1	2019-10-08 10:38:10.285106	94
1923452662	1	2019-10-08 10:38:14.367935	94
1923452653	2	2019-10-08 10:38:19.169413	1
1923452663	1	2019-10-08 10:38:23.115184	94
1923452664	1	2019-10-08 10:38:29.076489	66
1923452665	1	2019-10-08 10:38:37.291467	94
1923452666	1	2019-10-08 10:38:42.286848	94
1923452667	1	2019-10-08 10:38:48.552682	94
1923452668	1	2019-10-08 10:39:07.101139	94
1923452669	1	2019-10-08 10:39:11.981737	64
1923452670	1	2019-10-08 10:39:15.837712	94
1923452671	1	2019-10-08 10:39:16.78036	64
1923452672	1	2019-10-08 10:39:19.950529	94
1923452661	2	2019-10-08 10:40:40.698632	95
1923452663	2	2019-10-08 10:40:50.74745	95
1923452660	2	2019-10-08 10:40:54.200649	64
1923452666	2	2019-10-08 10:40:56.036245	95
1923452668	2	2019-10-08 10:41:01.21531	95
1923452655	2	2019-10-08 10:41:04.723821	95
1923452669	2	2019-10-08 10:41:09.363915	64
1923452672	2	2019-10-08 10:41:09.555069	95
1923452670	2	2019-10-08 10:41:16.194531	95
1923452654	2	2019-10-08 10:41:20.133474	64
1923452667	2	2019-10-08 10:41:21.348857	95
1923452665	2	2019-10-08 10:41:24.57021	95
1923452653	6	2019-10-08 10:41:26.794704	1
1923452662	2	2019-10-08 10:41:29.105315	95
1923452671	2	2019-10-08 10:41:35.535608	64
1923452654	6	2019-10-08 10:42:21.680988	64
1923452661	6	2019-10-08 10:43:35.897578	95
1923452660	5	2019-10-08 10:44:19.861857	64
1923452669	5	2019-10-08 10:44:25.281648	64
1923452671	5	2019-10-08 10:44:31.065562	64
1923452659	2	2019-10-08 10:45:08.861129	19
1923452659	5	2019-10-08 10:45:52.481918	19
1923452659	5	2019-10-08 10:45:52.483049	19
1923452659	4	2019-10-08 10:45:57.424159	95
1923452659	6	2019-10-08 10:46:20.213648	95
1923452666	5	2019-10-08 10:47:01.762431	95
1923452669	4	2019-10-08 10:48:05.867605	95
1923452669	4	2019-10-08 10:48:05.870747	95
1923452656	2	2019-10-08 10:48:19.510944	67
1923452669	6	2019-10-08 10:48:22.391692	95
1923452657	2	2019-10-08 10:48:39.312425	67
1923452657	2	2019-10-08 10:48:39.316257	67
1923452664	2	2019-10-08 10:48:49.488769	19
1923452656	5	2019-10-08 10:49:02.5173	67
1923452657	5	2019-10-08 10:49:09.988639	67
1923452671	4	2019-10-08 10:49:10.888997	95
1923452671	6	2019-10-08 10:49:16.248098	95
1923452664	5	2019-10-08 10:50:20.263073	19
1923452664	4	2019-10-08 10:50:23.795967	64
1923452664	6	2019-10-08 10:50:49.595164	64
1923452655	5	2019-10-08 10:52:54.739565	95
1923452665	5	2019-10-08 10:53:00.060062	95
1923452672	5	2019-10-08 10:53:05.830852	95
1923452673	1	2019-10-08 10:53:43.813236	7
1923452663	5	2019-10-08 10:54:28.685193	95
1923452662	5	2019-10-08 10:54:33.812527	95
1923452674	1	2019-10-08 10:54:44.064658	94
1923452660	4	2019-10-08 10:54:48.833252	67
1923452675	1	2019-10-08 10:54:53.429794	94
1923452660	6	2019-10-08 10:55:00.120758	67
1923452676	1	2019-10-08 10:55:01.243772	94
1923452670	5	2019-10-08 10:55:18.769814	95
1923452668	5	2019-10-08 10:55:27.449017	95
1923452667	5	2019-10-08 10:55:39.432435	95
1923452674	2	2019-10-08 10:55:58.411917	95
1923452674	2	2019-10-08 10:56:02.534937	95
1923452676	2	2019-10-08 10:56:09.843387	95
1923452675	2	2019-10-08 10:56:14.252049	95
1923452658	2	2019-10-08 10:56:34.104843	19
1923452658	5	2019-10-08 10:57:02.165985	19
1923452658	4	2019-10-08 10:57:11.457148	67
1923452675	5	2019-10-08 10:57:18.156633	95
1923452674	5	2019-10-08 10:57:23.235595	95
1923452658	6	2019-10-08 10:57:26.497873	67
1923452676	5	2019-10-08 10:57:27.60465	95
1923452663	4	2019-10-08 10:57:51.786638	67
1923452662	4	2019-10-08 10:58:09.142155	67
1923452675	4	2019-10-08 10:58:28.908395	67
1923452663	6	2019-10-08 10:58:47.139227	67
1923452675	6	2019-10-08 10:58:53.27444	67
1923452667	4	2019-10-08 10:59:33.967906	1
1923452668	4	2019-10-08 10:59:45.074761	64
1923452662	6	2019-10-08 10:59:46.20346	67
1923452676	4	2019-10-08 10:59:50.20223	1
1923452666	4	2019-10-08 10:59:56.823709	64
1923452665	4	2019-10-08 11:00:19.215377	64
1923452676	6	2019-10-08 11:00:19.793214	1
1923452667	6	2019-10-08 11:00:46.811282	1
1923452655	4	2019-10-08 11:00:56.610753	64
1923452672	4	2019-10-08 11:01:03.838433	64
1923452674	4	2019-10-08 11:01:11.727416	64
1923452673	2	2019-10-08 11:01:22.080286	1
1923452673	5	2019-10-08 11:01:30.766148	1
1923452666	5	2019-10-08 11:01:32.519212	64
1923452674	6	2019-10-08 11:01:39.391105	64
1923452665	6	2019-10-08 11:01:41.878835	64
1923452668	6	2019-10-08 11:01:45.026884	64
1923452672	6	2019-10-08 11:01:47.979177	64
1923452670	4	2019-10-08 11:01:49.684903	107
1923452655	6	2019-10-08 11:01:50.554491	64
1923452670	6	2019-10-08 11:02:06.680125	107
1923452666	4	2019-10-08 11:03:05.732666	20
1923452666	6	2019-10-08 11:03:25.050675	20
1923452677	1	2019-10-08 11:09:14.180407	74
1923452678	1	2019-10-08 11:11:39.784763	114
1923452679	1	2019-10-08 11:12:38.621641	114
1923452680	1	2019-10-08 11:13:13.27131	20
1923452681	1	2019-10-08 11:13:15.64962	114
1923452682	1	2019-10-08 11:13:16.922991	74
1923452683	1	2019-10-08 11:13:18.639673	74
1923452684	1	2019-10-08 11:13:24.598638	74
1923452685	1	2019-10-08 11:13:28.687426	74
1923452686	1	2019-10-08 11:13:31.91626	74
1923452687	1	2019-10-08 11:13:35.511754	74
1923452688	1	2019-10-08 11:13:41.847413	20
1923452689	1	2019-10-08 11:13:44.349666	20
1923452690	1	2019-10-08 11:13:47.283466	74
1923452691	1	2019-10-08 11:13:51.94317	74
1923452692	1	2019-10-08 11:13:54.28159	114
1923452693	1	2019-10-08 11:13:54.520249	20
1923452694	1	2019-10-08 11:13:58.126551	74
1923452695	1	2019-10-08 11:14:03.958549	74
1923452695	2	2019-10-08 11:14:25.914599	67
1923452694	2	2019-10-08 11:14:32.60669	67
1923452696	1	2019-10-08 11:14:33.377611	20
1923452691	2	2019-10-08 11:14:34.860867	67
1923452690	2	2019-10-08 11:14:37.816162	67
1923452697	1	2019-10-08 11:14:39.300255	114
1923452687	2	2019-10-08 11:14:40.689737	67
1923452683	2	2019-10-08 11:14:45.647798	67
1923452683	2	2019-10-08 11:14:47.790063	67
1923452682	2	2019-10-08 11:14:52.454064	67
1923452684	2	2019-10-08 11:14:55.928709	67
1923452685	2	2019-10-08 11:15:03.139473	67
1923452685	2	2019-10-08 11:15:04.088036	67
1923452686	2	2019-10-08 11:15:08.697528	67
1923452677	2	2019-10-08 11:15:10.97607	67
1923452686	2	2019-10-08 11:15:14.246514	67
1923452698	1	2019-10-08 11:16:43.605131	114
1923452683	6	2019-10-08 11:17:39.467625	67
1923452684	6	2019-10-08 11:17:43.424657	67
1923452682	6	2019-10-08 11:17:45.850459	67
1923452699	1	2019-10-08 11:17:46.517044	38
1923452686	6	2019-10-08 11:17:49.10919	67
1923452685	6	2019-10-08 11:17:54.896407	67
1923452700	1	2019-10-08 11:18:40.21799	39
1923452695	5	2019-10-08 11:19:07.166875	67
1923452701	1	2019-10-08 11:19:08.289028	39
1923452702	1	2019-10-08 11:19:08.292274	20
1923452703	1	2019-10-08 11:19:08.293584	20
1923452694	5	2019-10-08 11:19:09.722985	67
1923452691	5	2019-10-08 11:19:12.431958	67
1923452687	5	2019-10-08 11:19:17.107207	67
1923452690	5	2019-10-08 11:19:26.286011	67
1923452690	5	2019-10-08 11:19:26.286781	67
1923452704	1	2019-10-08 11:19:26.575422	20
1923452705	1	2019-10-08 11:19:27.806267	39
1923452706	1	2019-10-08 11:19:27.814358	39
1923452677	5	2019-10-08 11:19:29.966666	67
1923452707	1	2019-10-08 11:19:55.282848	20
1923452708	1	2019-10-08 11:20:41.959628	20
1923452709	1	2019-10-08 11:20:55.64267	20
1923452710	1	2019-10-08 11:21:01.311764	20
1923452700	2	2019-10-08 11:21:50.714494	64
1923452700	6	2019-10-08 11:22:47.616954	64
1923452700	6	2019-10-08 11:22:47.620591	64
1923452678	2	2019-10-08 11:24:20.07462	64
1923452678	5	2019-10-08 11:24:38.471514	64
1923452678	5	2019-10-08 11:24:38.472444	64
1923452679	2	2019-10-08 11:25:26.998378	64
1923452696	2	2019-10-08 11:25:43.176338	20
1923452680	2	2019-10-08 11:25:43.180802	20
1923452679	5	2019-10-08 11:25:46.686249	64
1923452702	2	2019-10-08 11:25:52.319704	20
1923452703	2	2019-10-08 11:25:56.34542	20
1923452707	2	2019-10-08 11:25:59.091765	20
1923452709	2	2019-10-08 11:26:03.416626	20
1923452697	2	2019-10-08 11:26:09.800044	64
1923452693	2	2019-10-08 11:26:10.665693	20
1923452708	2	2019-10-08 11:26:16.776393	20
1923452681	2	2019-10-08 11:26:20.035208	64
1923452704	2	2019-10-08 11:26:20.06719	20
1923452710	2	2019-10-08 11:26:24.011844	20
1923452688	2	2019-10-08 11:26:26.732804	20
1923452689	2	2019-10-08 11:26:29.30614	20
1923452692	2	2019-10-08 11:26:30.51009	64
1923452702	6	2019-10-08 11:26:40.022177	20
1923452697	5	2019-10-08 11:26:50.582038	64
1923452703	6	2019-10-08 11:26:52.207619	20
1923452703	6	2019-10-08 11:26:52.20826	20
1923452708	6	2019-10-08 11:26:55.880909	20
1923452681	5	2019-10-08 11:26:58.57909	64
1923452709	6	2019-10-08 11:26:59.751567	20
1923452707	6	2019-10-08 11:27:02.973536	20
1923452710	6	2019-10-08 11:27:06.932734	20
1923452704	6	2019-10-08 11:27:10.602188	20
1923452696	5	2019-10-08 11:28:52.538071	20
1923452680	5	2019-10-08 11:28:55.727818	20
1923452693	5	2019-10-08 11:29:02.66369	20
1923452688	5	2019-10-08 11:29:22.444711	20
1923452678	4	2019-10-08 11:29:26.759769	107
1923452689	5	2019-10-08 11:29:27.883995	20
1923452679	4	2019-10-08 11:30:06.972185	107
1923452696	4	2019-10-08 11:30:12.01422	67
1923452680	4	2019-10-08 11:30:12.014898	67
1923452693	4	2019-10-08 11:30:22.718593	67
1923452688	4	2019-10-08 11:30:34.957774	67
1923452697	4	2019-10-08 11:30:37.427456	107
1923452697	4	2019-10-08 11:30:37.428834	107
1923452689	4	2019-10-08 11:30:42.60533	67
1923452693	6	2019-10-08 11:30:55.765513	67
1923452688	6	2019-10-08 11:30:59.549747	67
1923452696	6	2019-10-08 11:31:03.739705	67
1923452689	6	2019-10-08 11:31:19.711324	67
1923452692	5	2019-10-08 11:31:20.058429	64
1923452680	6	2019-10-08 11:31:23.115935	67
1923452681	4	2019-10-08 11:31:26.552531	107
1923452692	4	2019-10-08 11:31:42.093997	107
1923452699	2	2019-10-08 11:32:02.73298	64
1923452678	6	2019-10-08 11:32:26.478977	107
1923452701	2	2019-10-08 11:32:34.108712	64
1923452698	2	2019-10-08 11:32:41.519384	64
1923452705	2	2019-10-08 11:32:48.584899	64
1923452706	2	2019-10-08 11:32:55.709175	64
1923452697	6	2019-10-08 11:33:13.604638	107
1923452679	6	2019-10-08 11:33:23.738143	107
1923452681	6	2019-10-08 11:33:28.919362	107
1923452692	6	2019-10-08 11:33:38.563596	107
1923452701	6	2019-10-08 11:35:06.235956	64
1923452706	6	2019-10-08 11:35:30.276113	64
1923452705	6	2019-10-08 11:35:55.32007	64
1923452705	6	2019-10-08 11:35:55.320713	64
1923452699	6	2019-10-08 11:36:14.951258	64
1923452698	6	2019-10-08 11:36:21.586106	64
1923452695	4	2019-10-08 11:36:40.228131	64
1923452694	4	2019-10-08 11:38:50.674607	64
1923452691	4	2019-10-08 11:39:18.332039	64
1923452690	4	2019-10-08 11:39:18.336471	64
1923452687	4	2019-10-08 11:39:46.778759	64
1923452677	4	2019-10-08 11:39:46.780895	64
1923452695	6	2019-10-08 11:40:29.120596	64
1923452694	6	2019-10-08 11:40:42.722371	64
1923452691	6	2019-10-08 11:40:55.229689	64
1923452690	6	2019-10-08 11:41:35.375288	64
1923452687	6	2019-10-08 11:42:06.772182	64
1923452687	6	2019-10-08 11:42:06.773757	64
1923452677	6	2019-10-08 11:42:35.558923	64
1923452711	1	2019-10-08 11:47:35.479644	14
1923452712	1	2019-10-08 11:47:48.797504	12
1923452713	1	2019-10-08 11:47:48.799985	14
1923452714	1	2019-10-08 11:48:18.042725	8
1923452715	1	2019-10-08 11:48:18.048992	1
1923452716	1	2019-10-08 11:48:33.272843	8
1923452717	1	2019-10-08 15:04:30.499381	31
1923452718	1	2019-10-08 15:12:04.1475	42
1923452718	2	2019-10-08 15:15:39.287805	64
1923452718	6	2019-10-08 15:17:41.777885	64
1923452719	1	2019-10-08 15:39:58.984941	3
1923452715	2	2019-10-08 15:42:10.384702	1
1923452716	2	2019-10-08 15:43:21.796564	1
1923452711	2	2019-10-08 15:44:08.150348	1
1923452712	2	2019-10-08 15:44:46.340348	1
1923452713	2	2019-10-08 15:45:30.483166	1
1923452714	2	2019-10-08 15:46:09.043493	1
1923452719	2	2019-10-08 15:46:32.898854	1
1923452719	6	2019-10-08 15:46:46.693548	1
1923452716	5	2019-10-08 15:46:55.279548	1
1923452714	5	2019-10-08 15:47:00.752911	1
1923452715	5	2019-10-08 15:47:05.882989	1
1923452712	5	2019-10-08 15:47:20.581903	1
1923452711	5	2019-10-08 15:47:26.146442	1
1923452713	5	2019-10-08 15:47:30.947263	1
1923452715	4	2019-10-08 15:48:10.394189	67
1923452715	6	2019-10-08 15:48:21.865206	67
1923452716	4	2019-10-08 15:49:31.131548	20
1923452714	4	2019-10-08 15:49:52.344448	20
1923452717	2	2019-10-08 15:50:39.062289	20
1923452716	6	2019-10-08 15:50:51.99951	20
1923452714	6	2019-10-08 15:50:57.06685	20
1923452717	5	2019-10-08 15:51:14.469181	20
1923452717	5	2019-10-08 15:51:14.469842	20
1923452717	4	2019-10-08 15:52:04.880634	67
1923452717	6	2019-10-08 15:52:19.342311	67
1923452711	4	2019-10-08 15:53:06.473336	107
1923452713	4	2019-10-08 15:53:29.929861	107
1923452711	6	2019-10-08 15:53:36.627333	107
1923452713	6	2019-10-08 15:53:41.925479	107
1923452712	4	2019-10-08 15:55:05.634012	95
1923452712	6	2019-10-08 15:55:14.81684	95
1923452720	1	2019-10-08 16:00:00.861286	20
1923452720	2	2019-10-08 16:02:49.410269	20
1923452720	5	2019-10-08 16:03:02.250737	20
1923452720	4	2019-10-08 16:04:09.143464	64
1923452720	6	2019-10-08 16:04:21.671471	64
1923452721	1	2019-10-09 13:59:28.300418	1
1923452721	2	2019-10-09 14:01:41.485993	1
1923452721	5	2019-10-09 14:01:54.241251	1
1923452721	4	2019-10-09 14:04:16.514299	67
1923452721	6	2019-10-09 14:04:30.234553	67
1923452722	1	2019-10-09 15:04:03.612187	21
1923452722	2	2019-10-09 15:05:42.83596	20
1923452722	6	2019-10-09 15:16:43.632891	20
1923452723	1	2019-10-10 10:08:08.601115	72
1923452723	2	2019-10-10 10:11:37.838447	67
1923452723	5	2019-10-10 10:12:19.322224	67
1923452723	4	2019-10-10 10:14:38.406671	1
1923452723	6	2019-10-10 10:17:11.304867	1
1923452724	1	2019-10-10 12:05:09.369477	42
1923452724	2	2019-10-10 12:10:23.031885	64
1923452724	5	2019-10-10 12:15:51.613861	64
1923452724	4	2019-10-10 12:22:40.049906	1
1923452724	6	2019-10-10 12:25:38.722021	1
1923452725	1	2019-10-10 12:33:45.809458	98
1923452725	2	2019-10-10 12:36:43.979077	95
1923452725	5	2019-10-10 12:39:08.029942	95
1923452725	4	2019-10-10 12:43:47.632825	67
1923452725	6	2019-10-10 12:45:39.227121	67
1923452726	1	2019-10-10 12:56:28.422177	1
1923452726	2	2019-10-10 12:59:32.647353	1
1923452726	6	2019-10-10 13:00:30.526348	1
1923452727	1	2019-10-10 13:05:28.684947	31
1923452728	1	2019-10-15 09:40:41.630989	20
1923452728	2	2019-10-15 09:43:28.519506	20
1923452727	2	2019-10-15 09:43:28.522155	20
1923452727	2	2019-10-15 09:43:44.25335	20
1923452727	5	2019-10-15 09:44:07.61563	20
1923452728	5	2019-10-15 09:44:20.325052	20
1923452727	4	2019-10-15 09:48:27.138643	1
1923452728	4	2019-10-15 09:48:35.478081	1
1923452727	6	2019-10-15 09:49:23.609798	1
1923452727	6	2019-10-15 09:49:23.611867	1
1923452727	6	2019-10-15 09:49:23.612527	1
1923452727	6	2019-10-15 09:49:23.613511	1
1923452727	6	2019-10-15 09:49:23.614581	1
1923452727	6	2019-10-15 09:49:23.621015	1
1923452728	6	2019-10-15 09:49:32.763134	1
1923452729	1	2019-10-15 09:50:18.072928	115
1923452729	2	2019-10-15 09:51:44.400979	1
1923452729	5	2019-10-15 09:53:11.429111	1
1923452729	4	2019-10-15 09:53:48.224685	107
1923452729	6	2019-10-15 09:54:49.577948	107
1923452730	1	2019-10-15 12:30:07.177668	61
1923452730	2	2019-10-15 12:30:41.016266	64
1923452730	5	2019-10-15 12:30:53.685873	64
1923452730	4	2019-10-15 12:32:44.747127	95
1923452730	6	2019-10-15 12:33:08.925719	95
1923452730	6	2019-10-15 12:33:08.92765	95
1923452730	6	2019-10-15 12:33:08.931034	95
1923452731	1	2019-10-15 15:16:44.951603	72
1923452731	2	2019-10-15 15:21:00.237787	67
1923452731	6	2019-10-15 15:27:14.22913	67
1923452732	1	2019-10-16 14:50:23.177837	12
1923452733	1	2019-10-16 14:56:25.601635	42
1923452733	2	2019-10-16 14:58:41.07599	64
1923452733	5	2019-10-16 14:58:52.806236	64
1923452733	4	2019-10-16 14:59:02.529164	20
1923452732	2	2019-10-16 15:09:33.38748	1
1923452732	6	2019-10-16 15:18:08.038096	1
1923452734	1	2019-10-17 09:03:55.701436	114
1923452734	2	2019-10-17 09:20:59.02984	64
1923452734	6	2019-10-17 09:43:47.738943	64
1923452735	1	2019-10-18 11:18:32.765114	66
1923452736	1	2019-10-18 11:19:14.815267	40
1923452737	1	2019-10-18 11:19:19.945701	40
1923452738	1	2019-10-18 11:19:28.108876	40
1923452739	1	2019-10-18 11:19:41.679506	40
1923452740	1	2019-10-18 11:19:45.121648	40
1923452735	2	2019-10-18 11:19:59.099157	19
1923452735	5	2019-10-18 11:20:13.112009	19
1923452736	2	2019-10-18 11:20:22.332537	64
1923452737	2	2019-10-18 11:20:25.751447	64
1923452738	2	2019-10-18 11:20:28.411839	64
1923452739	2	2019-10-18 11:20:30.854142	64
1923452740	2	2019-10-18 11:20:34.41655	64
1923452741	1	2019-10-18 11:21:27.947216	66
1923452739	5	2019-10-18 11:21:37.702973	64
1923452740	5	2019-10-18 11:21:41.24511	64
1923452736	5	2019-10-18 11:21:44.906228	64
1923452737	5	2019-10-18 11:21:53.937718	64
1923452738	5	2019-10-18 11:21:59.84809	64
1923452741	2	2019-10-18 11:22:19.863116	19
1923452741	5	2019-10-18 11:22:34.002986	19
1923452742	1	2019-10-18 11:22:56.615505	1
1923452743	1	2019-10-18 11:23:26.529565	66
1923452743	2	2019-10-18 11:23:56.949462	19
1923452743	5	2019-10-18 11:24:06.166316	19
1923452744	1	2019-10-18 11:24:33.848725	105
1923452745	1	2019-10-18 11:24:49.379179	105
1923452746	1	2019-10-18 11:25:09.770384	3
1923452747	1	2019-10-18 11:25:15.660074	105
1923452748	1	2019-10-18 11:25:29.300964	66
1923452749	1	2019-10-18 11:25:37.072281	105
1923452750	1	2019-10-18 11:25:51.395588	105
1923452735	4	2019-10-18 11:26:05.285033	64
1923452751	1	2019-10-18 11:26:11.595966	66
1923452741	4	2019-10-18 11:26:23.856284	64
1923452743	4	2019-10-18 11:26:36.703443	64
1923452748	2	2019-10-18 11:26:57.682505	19
1923452752	1	2019-10-18 11:27:07.868631	5
1923452751	2	2019-10-18 11:27:16.457813	19
1923452748	5	2019-10-18 11:27:29.26015	19
1923452751	5	2019-10-18 11:27:37.472012	19
1923452751	4	2019-10-18 11:27:41.231268	64
1923452748	4	2019-10-18 11:27:49.647235	64
1923452741	6	2019-10-18 11:28:03.631773	64
1923452743	6	2019-10-18 11:28:14.492781	64
1923452735	6	2019-10-18 11:28:18.465327	64
1923452751	6	2019-10-18 11:28:22.033459	64
1923452739	4	2019-10-18 11:28:26.853737	19
1923452748	6	2019-10-18 11:28:30.381605	64
1923452740	4	2019-10-18 11:28:40.513841	19
1923452736	4	2019-10-18 11:29:10.019741	19
1923452737	4	2019-10-18 11:29:21.805933	19
1923452738	4	2019-10-18 11:29:38.134182	19
1923452739	6	2019-10-18 11:30:45.985615	19
1923452740	6	2019-10-18 11:30:50.919909	19
1923452736	6	2019-10-18 11:30:57.407778	19
1923452737	6	2019-10-18 11:31:08.085042	19
1923452738	6	2019-10-18 11:31:14.325463	19
1923452753	1	2019-10-18 11:33:10.049485	7
1923452754	1	2019-10-18 11:33:19.006291	6
1923452752	2	2019-10-18 11:33:28.517623	1
1923452753	2	2019-10-18 11:33:46.91751	1
1923452754	2	2019-10-18 11:33:57.761611	1
1923452742	2	2019-10-18 11:34:28.122972	1
1923452746	2	2019-10-18 11:34:44.440347	1
1923452744	2	2019-10-18 11:35:15.267965	107
1923452750	2	2019-10-18 11:35:20.451652	107
1923452745	2	2019-10-18 11:35:26.721185	107
1923452749	2	2019-10-18 11:35:33.764287	107
1923452747	2	2019-10-18 11:35:38.645115	107
1923452746	5	2019-10-18 11:36:17.512786	1
1923452742	5	2019-10-18 11:36:28.311547	1
1923452752	5	2019-10-18 11:36:33.368499	1
1923452754	5	2019-10-18 11:36:37.453046	1
1923452753	5	2019-10-18 11:36:41.416318	1
1923452744	5	2019-10-18 11:36:57.677544	107
1923452745	5	2019-10-18 11:37:06.354186	107
1923452750	5	2019-10-18 11:37:11.304393	107
1923452749	5	2019-10-18 11:37:15.09316	107
1923452747	5	2019-10-18 11:37:19.714933	107
1923452746	4	2019-10-18 11:37:46.13115	107
1923452742	4	2019-10-18 11:37:56.439349	107
1923452752	4	2019-10-18 11:38:05.914179	107
1923452753	4	2019-10-18 11:38:12.779287	107
1923452754	4	2019-10-18 11:38:21.024454	107
1923452744	4	2019-10-18 11:40:50.807799	1
1923452745	4	2019-10-18 11:41:06.283256	1
1923452750	4	2019-10-18 11:41:19.96936	1
1923452755	1	2019-10-18 11:41:20.074134	1
1923452749	4	2019-10-18 11:41:32.441916	1
1923452747	4	2019-10-18 11:41:43.624988	1
1923452746	6	2019-10-18 11:41:50.177341	107
1923452742	6	2019-10-18 11:41:55.438887	107
1923452752	6	2019-10-18 11:42:04.301569	107
1923452754	6	2019-10-18 11:42:08.169281	107
1923452753	6	2019-10-18 11:42:12.60568	107
1923452755	2	2019-10-18 11:43:12.720134	1
1923452745	6	2019-10-18 11:43:59.682776	1
1923452750	6	2019-10-18 11:44:03.505103	1
1923452744	6	2019-10-18 11:44:08.164345	1
1923452749	6	2019-10-18 11:44:11.813301	1
1923452747	6	2019-10-18 11:44:16.237549	1
1923452755	5	2019-10-18 11:47:14.824022	1
1923452756	1	2019-10-18 11:52:26.671316	66
1923452757	1	2019-10-18 11:52:39.602641	105
1923452758	1	2019-10-18 11:52:55.703866	105
1923452759	1	2019-10-18 11:53:01.015115	105
1923452760	1	2019-10-18 11:53:05.777769	105
1923452761	1	2019-10-18 11:53:11.510696	105
1923452762	1	2019-10-18 11:53:22.185461	1
1923452763	1	2019-10-18 11:53:27.873275	66
1923452757	2	2019-10-18 11:53:46.651573	107
1923452758	2	2019-10-18 11:53:54.171544	107
1923452759	2	2019-10-18 11:53:56.886943	107
1923452760	2	2019-10-18 11:54:02.847723	107
1923452761	2	2019-10-18 11:54:08.670484	107
1923452757	6	2019-10-18 11:54:18.2666	107
1923452758	6	2019-10-18 11:54:21.953536	107
1923452759	6	2019-10-18 11:54:24.919089	107
1923452760	6	2019-10-18 11:54:27.642821	107
1923452764	1	2019-10-18 11:54:28.541766	66
1923452755	4	2019-10-18 11:54:30.00612	1
1923452761	6	2019-10-18 11:54:30.643187	107
1923452755	5	2019-10-18 11:55:20.340773	1
1923452765	1	2019-10-18 11:55:29.83722	66
1923452766	1	2019-10-18 11:56:49.361723	105
1923452767	1	2019-10-18 11:56:55.198283	105
1923452768	1	2019-10-18 11:57:05.417428	105
1923452769	1	2019-10-18 11:57:11.39542	105
1923452770	1	2019-10-18 11:57:18.274084	105
1923452771	1	2019-10-18 11:57:22.466784	3
1923452772	1	2019-10-18 11:57:44.702192	4
1923452773	1	2019-10-18 11:57:52.95625	2
1923452774	1	2019-10-18 11:57:54.151832	66
1923452766	2	2019-10-18 11:58:01.837103	107
1923452767	2	2019-10-18 11:58:04.912201	107
1923452768	2	2019-10-18 11:58:09.636098	107
1923452769	2	2019-10-18 11:58:15.945529	107
1923452770	2	2019-10-18 11:58:20.505672	107
1923452755	4	2019-10-18 11:58:20.65224	64
1923452766	5	2019-10-18 11:58:43.861857	107
1923452767	5	2019-10-18 11:58:49.519345	107
1923452768	5	2019-10-18 11:58:53.760672	107
1923452769	5	2019-10-18 11:58:57.324156	107
1923452770	5	2019-10-18 11:59:00.714075	107
1923452755	6	2019-10-18 11:59:30.136184	64
1923452756	2	2019-10-18 11:59:33.635172	19
1923452763	2	2019-10-18 11:59:40.744894	19
1923452764	2	2019-10-18 11:59:48.274519	19
1923452775	1	2019-10-18 11:59:48.702931	5
1923452765	2	2019-10-18 11:59:55.768099	19
1923452774	2	2019-10-18 12:00:01.389957	19
1923452756	5	2019-10-18 12:00:11.16475	19
1923452763	5	2019-10-18 12:00:15.223248	19
1923452764	5	2019-10-18 12:00:19.099639	19
1923452775	2	2019-10-18 12:00:21.494177	1
1923452765	5	2019-10-18 12:00:22.877693	19
1923452774	5	2019-10-18 12:00:26.995453	19
1923452762	2	2019-10-18 12:00:33.713416	1
1923452771	2	2019-10-18 12:00:40.12206	1
1923452772	2	2019-10-18 12:00:48.94115	1
1923452773	2	2019-10-18 12:00:57.867829	1
1923452776	1	2019-10-18 12:01:26.785714	66
1923452756	4	2019-10-18 12:01:40.228948	64
1923452763	4	2019-10-18 12:01:46.937021	64
1923452764	4	2019-10-18 12:01:53.825491	64
1923452765	4	2019-10-18 12:02:00.040522	64
1923452774	4	2019-10-18 12:02:05.809886	64
1923452775	5	2019-10-18 12:02:10.580847	1
1923452762	5	2019-10-18 12:02:14.991674	1
1923452756	6	2019-10-18 12:02:15.809042	64
1923452764	6	2019-10-18 12:02:19.626033	64
1923452771	5	2019-10-18 12:02:19.673659	1
1923452763	6	2019-10-18 12:02:22.400855	64
1923452772	5	2019-10-18 12:02:24.231195	1
1923452777	1	2019-10-18 12:02:25.361645	66
1923452774	6	2019-10-18 12:02:26.346192	64
1923452765	6	2019-10-18 12:02:29.693995	64
1923452773	5	2019-10-18 12:02:30.084099	1
1923452775	4	2019-10-18 12:02:52.218871	107
1923452762	4	2019-10-18 12:03:01.808425	107
1923452778	1	2019-10-18 12:03:11.928267	66
1923452771	4	2019-10-18 12:03:15.505475	107
1923452766	4	2019-10-18 12:03:17.032752	1
1923452772	4	2019-10-18 12:03:23.528711	107
1923452773	4	2019-10-18 12:03:30.066166	107
1923452767	4	2019-10-18 12:03:31.576783	1
1923452775	6	2019-10-18 12:03:35.527279	107
1923452762	6	2019-10-18 12:03:38.826014	107
1923452771	6	2019-10-18 12:03:41.580291	107
1923452768	4	2019-10-18 12:03:43.685623	1
1923452772	6	2019-10-18 12:03:45.520343	107
1923452773	6	2019-10-18 12:03:49.310727	107
1923452769	4	2019-10-18 12:04:00.308405	1
1923452779	1	2019-10-18 12:04:12.061075	66
1923452770	4	2019-10-18 12:04:15.468014	1
1923452768	6	2019-10-18 12:04:45.432405	1
1923452770	6	2019-10-18 12:04:48.92563	1
1923452767	6	2019-10-18 12:04:52.280395	1
1923452780	1	2019-10-18 12:04:54.952035	66
1923452766	6	2019-10-18 12:04:58.285713	1
1923452769	6	2019-10-18 12:05:08.349237	1
1923452781	1	2019-10-18 12:05:50.384651	66
1923452777	2	2019-10-18 12:06:42.011132	19
1923452778	2	2019-10-18 12:06:49.525484	19
1923452781	2	2019-10-18 12:06:59.30783	19
1923452776	2	2019-10-18 12:07:05.55929	19
1923452780	2	2019-10-18 12:07:14.027375	19
1923452779	2	2019-10-18 12:08:39.04644	19
1923452777	6	2019-10-18 12:09:06.887591	19
1923452781	6	2019-10-18 12:09:11.072744	19
1923452778	6	2019-10-18 12:09:19.528139	19
1923452776	6	2019-10-18 12:11:24.645551	19
1923452780	6	2019-10-18 12:11:29.130172	19
1923452779	6	2019-10-18 12:11:43.387547	19
1923452782	1	2019-10-18 12:12:01.178341	3
1923452783	1	2019-10-18 12:12:13.775165	2
1923452784	1	2019-10-18 12:12:26.295504	1
1923452785	1	2019-10-18 12:12:36.844893	5
1923452786	1	2019-10-18 12:12:48.176591	5
1923452785	2	2019-10-18 12:14:04.733976	1
1923452784	2	2019-10-18 12:14:14.132038	1
1923452783	2	2019-10-18 12:14:21.06787	1
1923452782	2	2019-10-18 12:14:30.329284	1
1923452786	2	2019-10-18 12:14:37.217681	1
1923452784	6	2019-10-18 12:15:54.112693	1
1923452783	6	2019-10-18 12:15:57.556332	1
1923452782	6	2019-10-18 12:16:01.010784	1
1923452786	6	2019-10-18 12:16:05.09185	1
1923452785	6	2019-10-18 12:16:10.055585	1
1923452787	1	2019-10-18 16:44:33.851839	67
1923452788	1	2019-10-22 11:30:28.982981	20
1923452788	2	2019-10-22 12:43:06.128436	20
1923452788	7	2019-10-22 13:17:41.079123	20
1923452789	1	2019-10-22 13:21:54.389023	20
1923452789	2	2019-10-24 08:39:56.350749	20
1923452788	5	2019-10-24 08:40:19.709617	20
1923452789	6	2019-10-24 08:40:46.1774	20
1923452733	6	2019-10-24 08:40:51.541256	20
1923452787	2	2019-10-31 14:26:33.303014	67
1923452787	5	2019-10-31 14:27:49.959881	67
1923452790	1	2019-11-04 16:30:00.241501	2
1923452791	1	2019-11-05 10:12:10.20781	1
1923452791	2	2019-11-05 10:13:00.974682	1
1923452791	6	2019-11-05 10:14:14.261992	1
1923452790	2	2019-11-05 10:18:25.782265	1
1923452790	5	2019-11-05 10:19:26.077889	1
1923452790	4	2019-11-05 10:24:54.4451	20
1923452792	1	2019-11-05 10:35:11.240052	1
1923452793	1	2019-11-05 10:35:11.29591	1
1923452794	1	2019-11-05 10:35:34.9657	1
1923452790	6	2019-11-06 08:57:28.210105	20
1923452795	1	2019-11-06 09:02:59.143917	93
1923452795	2	2019-11-06 09:05:43.778188	95
1923452795	6	2019-11-06 09:06:07.53794	95
1923452794	2	2019-11-06 11:00:54.686521	1
1923452793	2	2019-11-06 11:01:04.884329	1
1923452792	2	2019-11-06 11:01:10.951789	1
1923452792	6	2019-11-06 11:02:36.790788	1
1923452793	6	2019-11-06 11:02:54.235813	1
1923452794	6	2019-11-06 11:06:21.760283	1
1923452796	1	2019-11-06 11:06:48.479786	113
1923452797	1	2019-11-06 11:07:01.530689	89
1923452798	1	2019-11-06 11:08:14.382237	29
1923452799	1	2019-11-06 11:08:27.518172	96
1923452800	1	2019-11-06 11:09:32.36701	115
1923452800	2	2019-11-06 11:10:34.615938	1
1923452800	6	2019-11-06 11:11:46.665358	1
1923452799	2	2019-11-06 11:14:55.581653	95
1923452799	6	2019-11-06 11:15:03.405295	95
1923452801	1	2019-11-06 11:17:27.433495	93
1923452802	1	2019-11-06 11:17:29.110876	93
1923452803	1	2019-11-06 11:17:34.56885	93
1923452804	1	2019-11-06 11:17:37.413107	93
1923452805	1	2019-11-06 11:17:42.94236	96
1923452806	1	2019-11-06 11:17:48.013193	96
1923452807	1	2019-11-06 11:18:11.488737	96
1923452808	1	2019-11-06 11:18:16.556216	96
1923452809	1	2019-11-06 11:18:21.065866	103
1923452810	1	2019-11-06 11:18:25.88332	103
1923452811	1	2019-11-06 11:18:37.735088	66
1923452812	1	2019-11-06 11:18:43.769632	66
1923452813	1	2019-11-06 11:18:54.648684	50
1923452814	1	2019-11-06 11:18:58.898876	50
1923452815	1	2019-11-06 11:19:04.261886	50
1923452816	1	2019-11-06 11:19:17.960725	29
1923452817	1	2019-11-06 11:19:22.166749	29
1923452818	1	2019-11-06 11:19:28.511886	4
1923452819	1	2019-11-06 11:19:34.240919	4
1923452820	1	2019-11-06 11:19:38.94783	16
1923452813	2	2019-11-06 11:31:32.803312	64
1923452814	2	2019-11-06 11:32:23.195905	64
1923452815	2	2019-11-06 11:33:03.790657	64
1923452813	5	2019-11-06 11:37:42.44412	64
1923452814	5	2019-11-06 11:37:58.314626	64
1923452815	5	2019-11-06 11:38:12.047592	64
1923452797	2	2019-11-06 11:38:42.991465	95
1923452797	5	2019-11-06 11:39:53.298221	95
1923452797	4	2019-11-06 11:40:24.247785	20
1923452797	5	2019-11-06 11:40:31.477287	20
1923452798	2	2019-11-06 11:41:04.569489	20
1923452818	2	2019-11-06 11:41:11.137508	1
1923452816	2	2019-11-06 11:41:11.365713	20
1923452817	2	2019-11-06 11:41:27.542336	20
1923452819	2	2019-11-06 11:41:58.347239	1
1923452816	5	2019-11-06 11:41:59.159551	20
1923452817	5	2019-11-06 11:42:04.613958	20
1923452798	5	2019-11-06 11:42:11.696973	20
1923452820	2	2019-11-06 11:43:18.589372	1
1923452798	4	2019-11-06 11:43:23.088426	1
1923452820	5	2019-11-06 11:43:50.518968	1
1923452798	6	2019-11-06 11:44:56.524565	1
1923452818	5	2019-11-06 11:45:05.916203	1
1923452819	5	2019-11-06 11:45:32.149592	1
1923452811	2	2019-11-06 11:47:33.346256	19
1923452803	2	2019-11-06 11:48:22.168833	95
1923452804	2	2019-11-06 11:48:26.107249	95
1923452805	2	2019-11-06 11:48:27.661149	95
1923452806	2	2019-11-06 11:48:29.420627	95
1923452801	2	2019-11-06 11:48:32.166311	95
1923452802	2	2019-11-06 11:48:36.375789	95
1923452807	2	2019-11-06 11:48:38.188818	95
1923452808	2	2019-11-06 11:48:40.578547	95
1923452809	2	2019-11-06 11:48:42.613138	95
1923452812	2	2019-11-06 11:48:42.967283	19
1923452810	2	2019-11-06 11:48:44.426917	95
1923452811	5	2019-11-06 11:48:57.043706	19
1923452812	5	2019-11-06 11:49:02.32457	19
1923452808	5	2019-11-06 11:49:17.423636	95
1923452810	5	2019-11-06 11:49:21.255668	95
1923452809	5	2019-11-06 11:49:24.271009	95
1923452801	5	2019-11-06 11:49:28.046968	95
1923452804	5	2019-11-06 11:49:30.684828	95
1923452805	5	2019-11-06 11:49:33.739591	95
1923452806	5	2019-11-06 11:49:41.495215	95
1923452803	5	2019-11-06 11:49:46.635473	95
1923452802	5	2019-11-06 11:49:50.732432	95
1923452807	5	2019-11-06 11:49:54.45946	95
1923452803	4	2019-11-06 11:51:01.901973	67
1923452804	4	2019-11-06 11:51:17.248556	67
1923452805	4	2019-11-06 11:51:26.988745	67
1923452806	4	2019-11-06 11:51:36.265769	67
1923452801	4	2019-11-06 11:52:17.41967	67
1923452802	4	2019-11-06 11:52:17.939542	67
1923452806	6	2019-11-06 11:52:29.714456	67
1923452818	4	2019-11-06 11:52:41.321806	67
1923452805	6	2019-11-06 11:52:43.566347	67
1923452801	6	2019-11-06 11:53:00.243235	67
1923452819	4	2019-11-06 11:53:15.056429	67
1923452804	6	2019-11-06 11:53:17.069172	67
1923452820	4	2019-11-06 11:53:40.600638	67
1923452803	6	2019-11-06 11:53:47.861945	67
1923452802	6	2019-11-06 11:53:55.402688	67
1923452818	6	2019-11-06 11:54:00.02488	67
1923452819	6	2019-11-06 11:54:04.843957	67
1923452811	4	2019-11-06 11:54:24.007842	67
1923452812	4	2019-11-06 11:54:48.898527	67
1923452811	6	2019-11-06 11:56:32.539476	67
1923452812	6	2019-11-06 11:56:48.929121	67
1923452796	2	2019-11-06 11:59:40.402736	107
1923452796	5	2019-11-06 12:00:08.632343	107
1923452813	4	2019-11-06 12:00:53.916	107
1923452814	4	2019-11-06 12:01:06.933101	107
1923452815	4	2019-11-06 12:01:24.272391	107
1923452813	6	2019-11-06 12:02:04.763413	107
1923452814	6	2019-11-06 12:02:20.074371	107
1923452815	6	2019-11-06 12:02:34.812524	107
1923452820	5	2019-11-06 12:03:52.478209	67
1923452820	4	2019-11-06 12:04:24.87535	20
1923452820	6	2019-11-06 12:04:32.971411	20
1923452807	4	2019-11-06 12:05:03.59861	1
1923452796	4	2019-11-06 12:05:03.809054	1
1923452809	4	2019-11-06 12:05:20.470554	1
1923452810	4	2019-11-06 12:05:48.705027	1
1923452796	6	2019-11-06 12:06:36.31536	1
1923452810	6	2019-11-06 12:06:41.320625	1
1923452809	6	2019-11-06 12:06:45.440651	1
1923452807	6	2019-11-06 12:06:53.477838	1
1923452821	1	2019-11-06 12:07:51.606212	19
1923452822	1	2019-11-06 12:08:00.991788	17
1923452823	1	2019-11-06 12:08:12.784192	26
1923452824	1	2019-11-06 12:08:18.60784	20
1923452825	1	2019-11-06 12:08:26.749957	20
1923452826	1	2019-11-06 12:08:31.842684	54
1923452827	1	2019-11-06 12:08:42.760065	46
1923452816	4	2019-11-06 12:08:44.852871	95
1923452828	1	2019-11-06 12:08:47.772309	46
1923452829	1	2019-11-06 12:08:56.760627	46
1923452817	4	2019-11-06 12:08:58.886574	95
1923452830	1	2019-11-06 12:09:01.82173	29
1923452831	1	2019-11-06 12:09:08.86138	112
1923452832	1	2019-11-06 12:09:18.034893	112
1923452833	1	2019-11-06 12:09:34.797927	112
1923452816	6	2019-11-06 12:09:44.389751	95
1923452834	1	2019-11-06 12:09:44.470218	112
1923452835	1	2019-11-06 12:09:50.547991	112
1923452836	1	2019-11-06 12:10:05.770683	32
1923452837	1	2019-11-06 12:10:15.445118	32
1923452838	1	2019-11-06 12:10:31.542432	112
1923452839	1	2019-11-06 12:10:31.638665	112
1923452840	1	2019-11-06 12:10:36.364788	112
1923452817	6	2019-11-06 12:10:38.497599	95
1923452841	1	2019-11-06 12:10:52.495728	3
1923452842	1	2019-11-06 12:10:57.483415	91
1923452843	1	2019-11-06 12:11:01.545155	91
1923452844	1	2019-11-06 12:11:07.020999	56
1923452845	1	2019-11-06 12:11:11.022099	56
1923452846	1	2019-11-06 12:11:16.667447	8
1923452847	1	2019-11-06 12:11:28.789115	3
1923452848	1	2019-11-06 12:11:32.941806	3
1923452849	1	2019-11-06 12:11:39.188204	25
1923452850	1	2019-11-06 12:11:44.873409	7
1923452851	1	2019-11-06 12:11:51.247186	7
1923452852	1	2019-11-06 12:11:56.722993	1
1923452853	1	2019-11-06 12:12:03.178958	21
1923452854	1	2019-11-06 12:12:12.48982	75
1923452855	1	2019-11-06 12:12:46.870997	64
1923452856	1	2019-11-06 12:13:05.927678	64
1923452857	1	2019-11-06 12:13:15.54464	2
1923452858	1	2019-11-06 12:13:31.932376	66
1923452859	1	2019-11-06 12:13:35.648418	66
1923452860	1	2019-11-06 12:13:46.299902	22
1923452861	1	2019-11-06 12:13:56.989054	20
1923452862	1	2019-11-06 12:14:07.860916	22
1923452863	1	2019-11-06 12:14:14.626255	68
1923452847	2	2019-11-06 12:14:28.565037	1
1923452846	2	2019-11-06 12:16:15.15342	1
1923452848	2	2019-11-06 12:17:56.956171	1
1923452848	2	2019-11-06 12:18:10.352154	1
1923452822	2	2019-11-06 12:18:23.298761	1
1923452822	2	2019-11-06 12:18:23.410234	1
1923452822	2	2019-11-06 12:18:26.070005	1
1923452822	2	2019-11-06 12:18:29.871174	1
1923452850	2	2019-11-06 12:18:40.162222	1
1923452851	2	2019-11-06 12:18:47.717466	1
1923452826	2	2019-11-06 12:18:51.553009	64
1923452852	2	2019-11-06 12:19:00.912665	1
1923452852	2	2019-11-06 12:19:03.826694	1
1923452841	2	2019-11-06 12:19:10.375393	1
1923452857	2	2019-11-06 12:19:25.049742	1
1923452827	2	2019-11-06 12:20:00.764263	64
1923452851	5	2019-11-06 12:20:41.323724	1
1923452822	5	2019-11-06 12:21:15.068824	1
1923452857	5	2019-11-06 12:21:25.395225	1
1923452828	2	2019-11-06 12:21:38.474386	64
1923452841	5	2019-11-06 12:21:38.64938	1
1923452852	5	2019-11-06 12:21:48.506151	1
1923452850	5	2019-11-06 12:22:05.687252	1
1923452846	5	2019-11-06 12:22:14.535555	1
1923452829	2	2019-11-06 12:22:27.610704	64
1923452848	6	2019-11-06 12:22:31.904326	1
1923452847	6	2019-11-06 12:22:34.900414	1
1923452855	2	2019-11-06 12:23:01.217738	64
1923452852	4	2019-11-06 12:23:14.552701	95
1923452841	4	2019-11-06 12:23:45.632653	95
1923452844	2	2019-11-06 12:23:50.214328	64
1923452852	6	2019-11-06 12:24:05.234958	95
1923452841	6	2019-11-06 12:24:47.226095	95
1923452845	2	2019-11-06 12:24:47.433423	64
1923452856	2	2019-11-06 12:25:30.590037	64
1923452850	4	2019-11-06 12:25:36.939599	67
1923452822	4	2019-11-06 12:25:46.353109	67
1923452850	6	2019-11-06 12:26:09.648079	67
1923452822	6	2019-11-06 12:26:15.807411	67
1923452845	6	2019-11-06 12:26:40.982675	64
1923452844	6	2019-11-06 12:26:46.876936	64
1923452826	5	2019-11-06 12:26:58.364764	64
1923452829	5	2019-11-06 12:27:03.187168	64
1923452828	5	2019-11-06 12:27:15.455304	64
1923452827	5	2019-11-06 12:27:20.724361	64
1923452855	5	2019-11-06 12:27:24.778532	64
1923452856	5	2019-11-06 12:27:29.03828	64
1923452851	4	2019-11-06 12:28:25.749371	64
1923452851	6	2019-11-06 12:29:27.700026	64
1923452846	4	2019-11-06 12:29:31.376404	64
1923452846	6	2019-11-06 12:29:39.962968	64
1923452842	2	2019-11-06 12:29:55.255972	95
1923452857	4	2019-11-06 12:30:05.55825	64
1923452857	6	2019-11-06 12:30:18.847232	64
1923452843	2	2019-11-06 12:31:16.711828	95
1923452842	6	2019-11-06 12:31:48.088437	95
1923452843	6	2019-11-06 12:32:02.544091	95
1923452826	4	2019-11-06 12:32:52.167445	95
1923452826	5	2019-11-06 12:33:54.795101	95
1923452827	4	2019-11-06 12:34:16.979466	95
1923452828	4	2019-11-06 12:34:32.152235	95
1923452829	4	2019-11-06 12:34:52.404626	95
1923452854	2	2019-11-06 12:35:18.608146	67
1923452863	2	2019-11-06 12:35:21.795432	67
1923452854	5	2019-11-06 12:35:29.811921	67
1923452863	5	2019-11-06 12:35:34.719181	67
1923452863	4	2019-11-06 12:35:56.290146	19
1923452827	6	2019-11-06 12:36:00.619436	95
1923452854	4	2019-11-06 12:36:03.00359	19
1923452828	6	2019-11-06 12:36:05.782386	95
1923452854	6	2019-11-06 12:36:09.968748	19
1923452829	6	2019-11-06 12:36:10.780704	95
1923452863	5	2019-11-06 12:36:39.061228	19
1923452836	2	2019-11-06 12:37:35.671735	19
1923452855	4	2019-11-06 12:37:44.101512	107
1923452856	4	2019-11-06 12:38:15.802271	107
1923452837	2	2019-11-06 12:38:19.207998	19
1923452858	2	2019-11-06 12:38:42.002804	19
1923452856	6	2019-11-06 12:38:51.59332	107
1923452855	6	2019-11-06 12:38:56.226235	107
1923452859	2	2019-11-06 12:39:05.21278	19
1923452836	5	2019-11-06 12:39:12.355785	19
1923452837	5	2019-11-06 12:39:15.893264	19
1923452858	5	2019-11-06 12:39:20.145411	19
1923452859	5	2019-11-06 12:39:25.329132	19
1923452836	4	2019-11-06 12:39:50.058925	64
1923452837	4	2019-11-06 12:40:01.137855	64
1923452858	4	2019-11-06 12:40:09.093389	64
1923452859	4	2019-11-06 12:40:16.211459	64
1923452837	6	2019-11-06 12:40:26.832068	64
1923452836	6	2019-11-06 12:40:30.142906	64
1923452831	2	2019-11-06 12:40:32.703837	107
1923452858	6	2019-11-06 12:40:36.142648	64
1923452859	6	2019-11-06 12:40:39.489628	64
1923452832	2	2019-11-06 12:41:16.344322	107
1923452833	2	2019-11-06 12:41:49.634303	107
1923452834	2	2019-11-06 12:42:28.953684	107
1923452835	2	2019-11-06 12:43:11.457565	107
1923452849	2	2019-11-06 12:43:34.78567	20
1923452838	2	2019-11-06 12:43:44.859686	107
1923452821	2	2019-11-06 12:44:00.29146	20
1923452839	2	2019-11-06 12:44:19.437449	107
1923452823	2	2019-11-06 12:44:19.957943	20
1923452823	5	2019-11-06 12:44:35.185042	20
1923452824	2	2019-11-06 12:44:57.960162	20
1923452840	2	2019-11-06 12:45:01.609457	107
1923452825	2	2019-11-06 12:45:16.107137	20
1923452838	5	2019-11-06 12:45:16.432065	107
1923452839	5	2019-11-06 12:45:23.05732	107
1923452840	5	2019-11-06 12:45:30.484474	107
1923452853	2	2019-11-06 12:45:31.459458	20
1923452832	5	2019-11-06 12:45:35.9925	107
1923452831	5	2019-11-06 12:45:40.511232	107
1923452833	5	2019-11-06 12:45:44.393031	107
1923452830	2	2019-11-06 12:45:46.642274	20
1923452834	5	2019-11-06 12:45:48.80337	107
1923452835	5	2019-11-06 12:45:53.144718	107
1923452860	2	2019-11-06 12:46:03.986289	20
1923452861	2	2019-11-06 12:46:28.764469	20
1923452862	2	2019-11-06 12:46:45.429144	20
1923452830	5	2019-11-06 12:46:51.622217	20
1923452831	4	2019-11-06 12:46:57.587028	95
1923452861	5	2019-11-06 12:46:57.613847	20
1923452849	5	2019-11-06 12:47:01.975476	20
1923452853	5	2019-11-06 12:47:07.776155	20
1923452832	4	2019-11-06 12:47:09.135017	95
1923452824	5	2019-11-06 12:47:11.471923	20
1923452825	5	2019-11-06 12:47:16.290778	20
1923452821	5	2019-11-06 12:47:20.838243	20
1923452860	5	2019-11-06 12:47:25.169241	20
1923452862	5	2019-11-06 12:47:29.069622	20
1923452833	4	2019-11-06 12:47:40.968317	95
1923452834	4	2019-11-06 12:47:51.431882	95
1923452849	4	2019-11-06 12:47:56.815701	64
1923452853	4	2019-11-06 12:48:09.133549	64
1923452835	4	2019-11-06 12:48:09.419119	95
1923452830	4	2019-11-06 12:48:18.598111	64
1923452861	4	2019-11-06 12:48:39.224007	64
1923452838	4	2019-11-06 12:48:40.971192	95
1923452830	6	2019-11-06 12:48:50.302923	64
1923452839	4	2019-11-06 12:48:55.10324	95
1923452840	4	2019-11-06 12:49:16.717486	95
1923452853	6	2019-11-06 12:49:27.611342	64
1923452832	6	2019-11-06 12:49:52.499056	95
1923452849	6	2019-11-06 12:49:53.205951	64
1923452861	6	2019-11-06 12:50:02.504775	64
1923452839	6	2019-11-06 12:50:30.865787	95
1923452823	4	2019-11-06 12:51:04.88233	107
1923452831	6	2019-11-06 12:51:14.661483	95
1923452860	4	2019-11-06 12:51:22.422216	107
1923452838	6	2019-11-06 12:51:26.956556	95
1923452862	4	2019-11-06 12:51:36.073897	107
1923452835	6	2019-11-06 12:51:40.292569	95
1923452860	6	2019-11-06 12:51:49.15171	107
1923452840	6	2019-11-06 12:51:52.528713	95
1923452834	6	2019-11-06 12:51:59.589344	95
1923452823	6	2019-11-06 12:51:59.75755	107
1923452833	6	2019-11-06 12:52:14.143277	95
1923452862	6	2019-11-06 12:52:17.437038	107
1923452821	4	2019-11-06 12:53:03.73971	95
1923452825	4	2019-11-06 12:53:55.595982	95
1923452824	4	2019-11-06 12:54:19.110069	95
1923452821	6	2019-11-06 12:54:19.624621	95
1923452825	6	2019-11-06 12:54:24.868495	95
1923452824	6	2019-11-06 12:54:33.88478	95
1923452864	1	2019-11-06 12:59:34.020891	78
1923452865	1	2019-11-06 12:59:44.294682	82
1923452866	1	2019-11-06 12:59:50.452368	114
1923452867	1	2019-11-06 12:59:57.659942	4
1923452868	1	2019-11-06 13:00:03.036803	4
1923452869	1	2019-11-06 13:00:06.987565	19
1923452870	1	2019-11-06 13:00:15.697291	66
1923452871	1	2019-11-06 13:00:23.595115	102
1923452872	1	2019-11-06 13:00:27.612428	102
1923452873	1	2019-11-06 13:00:31.642709	85
1923452874	1	2019-11-06 13:00:35.793124	88
1923452875	1	2019-11-06 13:00:49.465953	110
1923452876	1	2019-11-06 13:00:54.698472	110
1923452877	1	2019-11-06 13:01:10.674359	88
1923452878	1	2019-11-06 13:01:17.005406	88
1923452879	1	2019-11-06 13:01:23.995707	40
1923452880	1	2019-11-06 13:01:31.134538	84
1923452881	1	2019-11-06 13:01:48.900638	84
1923452882	1	2019-11-06 13:02:11.697016	20
1923452883	1	2019-11-06 13:02:26.491982	71
1923452884	1	2019-11-06 13:02:33.977979	75
1923452885	1	2019-11-06 13:02:43.876467	76
1923452886	1	2019-11-06 13:02:49.529198	78
1923452887	1	2019-11-06 13:02:53.56417	78
1923452888	1	2019-11-06 13:03:01.826774	72
1923452889	1	2019-11-06 13:03:08.115184	72
1923452890	1	2019-11-06 13:06:00.32866	76
1923452891	1	2019-11-06 13:06:14.577456	68
1923452892	1	2019-11-06 13:06:24.459806	68
1923452893	1	2019-11-06 13:06:36.67687	39
1923452894	1	2019-11-06 13:06:40.347908	115
1923452895	1	2019-11-06 13:06:42.932281	62
1923452896	1	2019-11-06 13:06:55.155208	113
1923452897	1	2019-11-06 13:07:17.705971	20
1923452898	1	2019-11-06 13:07:38.347392	20
1923452879	2	2019-11-06 13:07:47.517228	64
1923452899	1	2019-11-06 13:07:57.587086	115
1923452900	1	2019-11-06 13:08:05.241972	107
1923452879	6	2019-11-06 13:08:07.132802	64
1923452901	1	2019-11-06 13:08:11.750158	115
1923452902	1	2019-11-06 13:08:29.84697	42
1923452903	1	2019-11-06 13:08:31.078477	44
1923452904	1	2019-11-06 13:08:38.838498	44
1923452905	1	2019-11-06 13:10:09.832495	68
1923452906	1	2019-11-06 13:10:12.829558	17
1923452869	2	2019-11-06 13:11:31.351834	20
1923452882	2	2019-11-06 13:12:24.980962	20
1923452897	2	2019-11-06 13:13:17.454789	20
1923452898	2	2019-11-06 13:14:31.456119	20
1923452869	5	2019-11-06 13:14:58.880083	20
1923452898	5	2019-11-06 13:15:06.852011	20
1923452882	5	2019-11-06 13:15:13.333343	20
1923452897	5	2019-11-06 13:15:21.313681	20
1923452894	2	2019-11-06 13:17:15.957791	1
1923452901	2	2019-11-06 13:17:58.896601	1
1923452899	2	2019-11-06 13:18:50.83546	1
1923452867	2	2019-11-06 13:19:35.351909	1
1923452868	2	2019-11-06 13:20:09.762523	1
1923452906	2	2019-11-06 13:20:52.707487	1
1923452894	5	2019-11-06 13:21:14.050737	1
1923452906	5	2019-11-06 13:21:29.520822	1
1923452867	5	2019-11-06 13:21:37.759019	1
1923452868	5	2019-11-06 13:21:49.856352	1
1923452901	5	2019-11-06 13:22:00.097829	1
1923452899	5	2019-11-06 13:22:16.121965	1
1923452870	2	2019-11-06 13:26:05.180486	19
1923452870	5	2019-11-06 13:26:17.80402	19
1923452881	2	2019-11-06 13:29:40.916648	67
1923452886	2	2019-11-06 13:30:53.294376	67
1923452887	2	2019-11-06 13:32:12.718161	67
1923452884	2	2019-11-06 13:32:43.031517	67
1923452880	2	2019-11-06 14:52:53.720241	67
1923452889	2	2019-11-06 14:53:35.83724	67
1923452888	2	2019-11-06 14:54:29.099806	67
1923452885	2	2019-11-06 14:55:23.555493	67
1923452890	2	2019-11-06 14:56:23.615737	67
1923452873	2	2019-11-06 15:00:04.569615	67
1923452865	2	2019-11-06 15:00:43.599532	67
1923452864	2	2019-11-06 15:01:15.890439	67
1923452905	2	2019-11-06 15:02:30.729311	67
1923452883	2	2019-11-06 15:03:21.43256	67
1923452891	2	2019-11-06 15:04:54.046867	67
1923452892	2	2019-11-06 15:05:31.545344	67
1923452881	5	2019-11-06 15:06:28.532767	67
1923452887	5	2019-11-06 15:06:39.306648	67
1923452889	5	2019-11-06 15:07:00.667456	67
1923452886	5	2019-11-06 15:07:10.958669	67
1923452888	5	2019-11-06 15:07:24.448836	67
1923452885	5	2019-11-06 15:07:40.512366	67
1923452873	5	2019-11-06 15:07:56.469656	67
1923452890	5	2019-11-06 15:08:22.028543	67
1923452883	5	2019-11-06 15:08:58.79749	67
1923452892	5	2019-11-06 15:09:14.424948	67
1923452891	5	2019-11-06 15:09:29.506398	67
1923452905	5	2019-11-06 15:09:44.087597	67
1923452884	5	2019-11-06 15:10:07.767515	67
1923452864	5	2019-11-06 15:10:38.8273	67
1923452865	5	2019-11-06 15:11:22.117248	67
1923452880	6	2019-11-06 15:13:11.356836	67
1923452896	2	2019-11-06 15:15:16.412532	107
1923452900	2	2019-11-06 15:15:57.092341	107
1923452875	2	2019-11-06 15:32:23.692113	107
1923452876	2	2019-11-06 15:32:51.15445	107
1923452900	6	2019-11-06 15:33:13.919841	107
1923452893	2	2019-11-06 15:37:05.631417	64
1923452866	2	2019-11-06 15:37:40.740288	64
1923452895	2	2019-11-06 15:38:35.950127	64
1923452902	2	2019-11-06 15:39:18.485552	64
1923452903	2	2019-11-06 15:39:59.82631	64
1923452904	2	2019-11-06 15:40:45.96798	64
1923452871	2	2019-11-06 15:43:09.04556	95
1923452872	2	2019-11-06 15:43:36.428842	95
1923452874	2	2019-11-06 15:44:07.466021	95
1923452877	2	2019-11-06 15:44:50.648245	95
1923452878	2	2019-11-06 15:45:17.518702	95
1923452874	6	2019-11-06 15:45:35.032849	95
1923452871	6	2019-11-06 15:45:45.724651	95
1923452872	6	2019-11-06 15:45:56.637385	95
1923452877	6	2019-11-06 15:45:59.959562	95
1923452878	6	2019-11-06 15:46:04.395993	95
1923452902	5	2019-11-06 15:49:21.473901	64
1923452893	5	2019-11-06 15:49:32.658578	64
1923452903	5	2019-11-06 15:49:42.227678	64
1923452904	5	2019-11-06 15:49:54.524256	64
1923452866	5	2019-11-06 15:50:13.317455	64
1923452895	5	2019-11-06 15:50:27.108871	64
1923452869	4	2019-11-06 15:51:15.666094	64
1923452869	5	2019-11-06 15:52:05.560043	64
1923452882	4	2019-11-06 15:52:26.624064	64
1923452897	4	2019-11-06 15:52:46.070499	64
1923452898	4	2019-11-06 15:52:56.544148	64
1923452884	4	2019-11-06 15:54:40.049314	64
1923452884	6	2019-11-06 15:55:32.658301	64
1923452898	6	2019-11-06 15:55:38.885498	64
1923452897	6	2019-11-06 15:55:41.501806	64
1923452882	6	2019-11-06 15:55:44.851185	64
1923452896	5	2019-11-06 15:56:34.573234	107
1923452876	5	2019-11-06 15:56:43.576238	107
1923452875	5	2019-11-06 15:56:52.468645	107
1923452906	4	2019-11-06 15:57:38.594936	107
1923452905	4	2019-11-06 15:58:06.767692	107
1923452883	4	2019-11-06 15:58:29.460331	107
1923452891	4	2019-11-06 15:58:47.963274	107
1923452892	4	2019-11-06 15:58:59.788778	107
1923452895	4	2019-11-06 15:59:19.828122	107
1923452906	6	2019-11-06 15:59:49.728736	107
1923452895	6	2019-11-06 15:59:52.762182	107
1923452905	6	2019-11-06 15:59:55.566715	107
1923452891	6	2019-11-06 15:59:58.894013	107
1923452892	6	2019-11-06 16:00:01.370442	107
1923452883	6	2019-11-06 16:00:04.014515	107
1923452869	4	2019-11-06 16:02:40.949385	67
1923452894	4	2019-11-06 16:03:15.279127	67
1923452901	4	2019-11-06 16:03:32.930105	67
1923452899	4	2019-11-06 16:03:46.849088	67
1923452903	4	2019-11-06 16:04:21.21463	67
1923452904	4	2019-11-06 16:04:32.580215	67
1923452899	6	2019-11-06 16:04:44.16584	67
1923452901	6	2019-11-06 16:04:47.079143	67
1923452894	6	2019-11-06 16:04:49.595604	67
1923452903	6	2019-11-06 16:04:52.021736	67
1923452904	6	2019-11-06 16:04:54.220589	67
1923452869	6	2019-11-06 16:04:56.622616	67
1923452868	4	2019-11-06 16:06:24.8734	95
1923452867	4	2019-11-06 16:06:36.717722	95
1923452870	4	2019-11-06 16:06:52.682246	95
1923452889	4	2019-11-06 16:07:40.087945	95
1923452888	4	2019-11-06 16:07:55.34067	95
1923452885	4	2019-11-06 16:08:10.16118	95
1923452890	4	2019-11-06 16:08:21.769494	95
1923452873	4	2019-11-06 16:08:34.77487	95
1923452865	4	2019-11-06 16:09:16.180561	95
1923452864	4	2019-11-06 16:09:26.617914	95
1923452866	4	2019-11-06 16:09:52.929299	95
1923452889	6	2019-11-06 16:10:53.309867	95
1923452888	6	2019-11-06 16:10:55.852536	95
1923452870	6	2019-11-06 16:10:58.27902	95
1923452885	6	2019-11-06 16:11:00.678619	95
1923452890	6	2019-11-06 16:11:03.140955	95
1923452866	6	2019-11-06 16:11:05.377248	95
1923452867	6	2019-11-06 16:11:07.551574	95
1923452868	6	2019-11-06 16:11:09.775563	95
1923452873	6	2019-11-06 16:11:11.916362	95
1923452865	6	2019-11-06 16:11:14.188717	95
1923452864	6	2019-11-06 16:11:16.171491	95
1923452893	4	2019-11-06 16:12:35.398472	19
1923452893	6	2019-11-06 16:12:44.701477	19
1923452907	1	2019-11-11 10:04:33.289514	81
1923452907	2	2019-11-11 10:36:41.793823	67
1923452907	5	2019-11-11 10:36:51.754592	67
1923452907	4	2019-11-11 10:38:20.802106	64
1923452908	1	2019-11-11 11:11:10.397458	67
1923452909	1	2019-11-11 15:34:05.707863	20
1923452908	2	2019-11-12 09:28:00.691771	67
1923452907	7	2019-11-12 11:22:02.485898	64
1923452907	7	2019-11-12 11:22:22.642396	64
1923452910	1	2019-11-12 15:42:02.597302	5
1923452911	1	2019-11-12 16:16:24.976456	5
1923452907	6	2019-11-12 16:17:40.107739	64
1923452910	2	2019-11-13 10:24:03.257773	1
1923452911	2	2019-11-13 10:24:10.77128	1
1923452911	5	2019-11-13 10:24:19.26396	1
1923452910	5	2019-11-13 10:24:24.845885	1
1923452909	2	2019-11-13 10:25:40.381206	20
1923452908	5	2019-11-13 10:26:16.227592	67
1923452910	4	2019-11-13 10:26:36.341258	67
1923452910	6	2019-11-13 10:26:43.96441	67
1923452909	6	2019-11-13 10:26:53.155461	20
1923452911	4	2019-11-13 10:27:28.647932	64
1923452908	4	2019-11-13 10:27:39.972085	64
1923452908	6	2019-11-13 10:27:52.030483	64
1923452911	6	2019-11-13 10:28:02.148137	64
1923452912	1	2019-11-13 10:29:00.3528	20
1923452912	2	2019-11-13 16:09:49.529162	20
1923452912	6	2019-11-13 16:09:56.261368	20
1923452913	1	2019-11-18 10:16:56.908393	1
1923452913	2	2019-11-18 10:33:50.22154	1
1923452913	5	2019-11-18 10:44:15.862492	1
1923452913	4	2019-11-18 10:46:10.94751	64
1923452913	6	2019-11-18 10:50:05.725711	64
1923452914	1	2019-11-18 14:15:04.159275	20
1923452914	2	2019-11-18 14:30:27.228387	20
1923452914	6	2019-11-18 14:33:17.106427	20
1923452915	1	2019-11-18 14:44:09.638963	2
1923452915	2	2019-11-18 15:08:04.213398	1
1923452915	6	2019-11-18 15:11:14.318118	1
1923452916	1	2019-11-18 15:27:22.241794	1
1923452916	2	2019-11-18 15:35:38.729953	1
1923452916	5	2019-11-18 15:40:37.953063	1
1923452916	4	2019-11-18 15:41:47.996735	20
1923452916	6	2019-11-18 15:43:10.023808	20
1923452917	1	2019-11-20 09:12:33.541056	94
1923452917	2	2019-11-20 09:17:12.612453	95
1923452917	5	2019-11-20 09:17:52.889461	95
\.


--
-- TOC entry 3106 (class 0 OID 18158)
-- Dependencies: 203
-- Data for Name: user_updates; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_updates (user_id, first_name, last_name, phone, time_updated) FROM stdin;
57	Behouba Manassé	Kouamé	+225 99 93 10 92	2019-08-28 02:55:00.815909
57	Behouba Manassé	Kouamé	45001685	2019-08-28 03:00:19.516313
57	Behouba Manassé	Kouamé	45001686	2019-08-28 03:00:42.611421
57	Behouba Mana	Kouamé	45001686	2019-08-28 17:39:14.17858
57	Behouba Mana	Kouamé	45001686	2019-08-28 17:39:20.014172
57	Behouba Manassé 	Kouamé	45001686	2019-08-28 17:40:07.735089
57	Behouba Manassé	Kouamé	45001686	2019-08-28 17:40:17.36473
57	Behouba Manassé	Kouamé	45001685	2019-08-29 21:43:18.397771
57	Behouba Manassé	Kouamé	99931092	2019-08-31 12:43:43.730105
57	Behouba Mana	Kouamé	99931092	2019-08-31 12:44:20.194873
57	Behouba Manassé	Kouamé	45001685	2019-08-31 12:44:33.657718
57	Behouba Manassé	Kouamé	45001685	2019-08-31 12:44:59.833718
57	Behouba Manassé	Kouamé	45001685	2019-09-08 07:41:55.917426
57	Behouba Manass	Kouamé	45001685	2019-09-08 07:59:08.780575
57	Behouba Manassé	Kouamé	45001685	2019-09-18 06:00:01.483795
59	Valérie	Oué	49203638	2019-09-19 11:23:36.753431
59	Valérie	Oué	49203638	2019-09-19 11:23:43.830866
57	Behouba Manassé	Kouamé	45001686	2019-10-04 12:40:31.4589
58	Mie	Chou	59990049	2019-10-05 19:03:53.858074
58	Cha	Aï	59990049	2019-10-06 09:38:17.065549
71	ouattara	soualio	78830760	2019-10-08 15:15:36.875388
57	Behouba Manassé	Kouamé	45001686	2019-10-30 21:13:39.500757
71	Benzou 	Benzou 	78830760	2019-11-05 17:27:09.207033
73	ISMAEL	ISSOUFOU	79793937	2019-11-07 10:32:44.395993
\.


--
-- TOC entry 3107 (class 0 OID 18165)
-- Dependencies: 204
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (user_id, first_name, last_name, phone, email, password, account_type_id, is_email_verified, is_phone_verified, is_active, recovery_token) FROM stdin;
75	Abou bakari	Bako	08532771	Boubabako5@gmail.com	$2a$04$SDxeefQgPY7MoOGypVpGLuhF2zjdadiulR13wS6DESYIOIJXEJuue	1	f	f	t	\N
70	Oumar	ZERBO	89865492	ozerbo5@gmail.com	$2a$04$Yw3gRIOiraJUcZ/cW6iDQO01NIl1z4SKqH2ugRy92BJnmx8GKSLMi	1	f	f	t	$2a$10$SW.B3SBnkE7zVApoN/Jg2.NJkjnCO.BgyRv1fU6LOqpSEMigEbepm
79	Bi Jean Marcel	Zamblé	07463217	meraf.ci@gmail.com	$2a$04$91455lweSXMP/56PNRv9NOwT6AP1OXXnEVgwFLKEhoupzL3Nm5bbu	1	f	f	t	\N
1	Akwaba	Express	20370174	contact@akwabaexpress.ci	akwabaexpressisgreat	3	f	f	t	\N
60	Jocelyne	NIONGUI	07822971	joceniongui@gmail.com	$2a$04$Cmm/QL5ByWobdGNvXUcc7uzCY8m0Tt9Ck/eLCmv3Os.oNIzRkrTgy	1	f	f	t	\N
61	franck	moh	08729981	mohassemien123@gmail.COM	$2a$04$KvVoILMpuQqNdidOKqmLn..J3wgd7XDdSwcU.3RvMFEWaxnyDHMny	1	f	f	t	\N
59	Valérie	Oué	49203638	valerieaimeendri0808@gmail.com	$2a$04$g2msvybceH.fNQ8lgjKyUumC25cMjtIN0QTbxq1TZr7xdPasHuPZe	1	f	f	t	\N
64	Marcellin	Kouassi	07507384	kmarcelk03@gmail.com	$2a$04$s2p/wlosunoj7J7F/sIwkO6JUTTuYdZ77aC4wHBk7my0J2Rs.mMxy	1	f	f	t	\N
65	YAO ISIDORE	ASSIE	57715955	isidoreyaoassie01@gmail.com	$2a$04$RHWBsQBsKNO/9Ot/xq2BPuiqJ58KaZfJV77xQ095MoO3DoByiYaTa	1	f	f	t	\N
68	emeline	katerine	65974125	emeline123@gmail.com	$2a$04$ERut7h4uRLdYtPeHKn8ppOHkfykn.mr2jKUNd.aGJ7FVTQE5OXD2O	1	f	f	t	\N
57	Behouba Manassé	Kouamé	45001686	behouba@gmail.com	$2a$04$S6O62ig6Q7U1AXw43bvhIeCUyFF7YUZqluB5n6adtD.WU3fde2c3e	1	t	f	t	\N
58	Mie	Chou	59990049	aichasorop@gmail.com	$2a$04$BfbT4ANru9Ek.D0vf6bQpOTQmHeed4cr8NwHYzEJtnhDuC0XZT4Hy	1	f	f	t	\N
72	Abdoul hadi 	Ouedraogo 	49859528	Oudraogo7@gmail.com	$2a$04$L5VPbO7OxFNfAt6Z5RQJM.xZBFjr8sq2yV8YsZ4aXvD2J0F5sMj2C	1	f	f	t	\N
62	aissata	ouattara	57612462	ouattaraaissata43@gmail.com	$2a$04$92CmXQnqlYHVRnHNx8WQB.otdtMZUjDhml4s9lwq/b2vSebytveBW	1	t	f	t	\N
71	Benzou 	Benzou 	78830760	kassinabien01@gmail.com	$2a$04$DNu55b02xMDKNzGIUWsySOre2AK72ACpzoDHQ7l4qSfFc3IVDpUZ2	1	f	f	t	\N
73	ISMAEL	ISSOUFOU	79793937	ism1717@akwabaexpress.ci	$2a$04$XK87gpykLAjQX/pK/6O8w.JqFRxAp2JV96.Zt02rG6T9sXeJnoSCG	1	t	f	t	\N
80	Diouf 	pape 	49705128	pape96345@gmail.com	$2a$04$apqKMMLVrc7eDBlbvzAL9ukwMsHujsjCDoWN.Mkt2P19o/Ya4xHq.	1	f	f	t	\N
81	Axel Nan Emmanuella 	ZOROBI 	07182484	ezorobi@gmail.com	$2a$04$4bnlPCyak15G8qXdHIUfpuKligCDiiun.tncXnHgpiGJ1CeUJnneK	1	f	f	t	\N
82	dane	amani	09783919	daneamani2@gmail.com	$2a$04$x58GA31iQ70kg5pjVjHI9uIC46mN8Hiu/ZOZqlTf20Beu7NDRcG.e	1	f	f	t	\N
\.


--
-- TOC entry 3108 (class 0 OID 18176)
-- Dependencies: 205
-- Data for Name: users_access_history; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users_access_history (user_id, access_time, ip_address, is_from_mobile) FROM stdin;
57	2019-08-28 01:15:13.088448	127.0.0.1	\N
57	2019-08-28 02:10:41.776597	127.0.0.1	\N
57	2019-08-28 02:14:03.23573	127.0.0.1	\N
57	2019-08-28 02:54:34.017864	127.0.0.1	\N
57	2019-08-28 03:01:19.149807	127.0.0.1	\N
57	2019-08-28 10:03:43.071448	127.0.0.1	\N
57	2019-08-28 14:40:27.50475	127.0.0.1	\N
57	2019-08-28 17:36:23.771365	127.0.0.1	\N
57	2019-08-28 17:38:50.757781	127.0.0.1	\N
57	2019-08-29 00:44:09.194648	127.0.0.1	\N
57	2019-08-29 15:00:26.797696	127.0.0.1	\N
57	2019-08-29 19:32:11.475058	127.0.0.1	\N
57	2019-08-31 12:39:29.735755	127.0.0.1	\N
57	2019-09-03 13:41:25.050794	127.0.0.1	\N
57	2019-09-03 13:43:57.119867	127.0.0.1	\N
57	2019-09-03 14:49:26.636281	127.0.0.1	\N
57	2019-09-03 17:24:28.177078	127.0.0.1	\N
57	2019-09-03 18:10:28.062863	127.0.0.1	\N
57	2019-09-03 21:17:47.271194	127.0.0.1	\N
58	2019-09-04 12:08:26.508433	127.0.0.1	\N
58	2019-09-04 12:26:49.044344	127.0.0.1	\N
57	2019-09-04 12:40:03.846388	127.0.0.1	\N
57	2019-09-04 13:29:55.252973	127.0.0.1	\N
58	2019-09-04 17:41:57.326065	127.0.0.1	\N
57	2019-09-06 10:54:41.654143	127.0.0.1	\N
57	2019-09-06 11:17:02.491377	127.0.0.1	\N
57	2019-09-06 18:30:50.442897	127.0.0.1	\N
58	2019-09-08 09:58:44.468018	127.0.0.1	\N
57	2019-09-09 05:05:10.742221	127.0.0.1	\N
57	2019-09-09 17:41:33.315437	127.0.0.1	\N
57	2019-09-10 05:48:02.086891	127.0.0.1	\N
58	2019-09-10 15:10:40.205022	127.0.0.1	\N
58	2019-09-10 18:02:31.421181	127.0.0.1	\N
57	2019-09-13 20:23:44.516341	127.0.0.1	\N
58	2019-09-19 08:56:50.093059	127.0.0.1	\N
58	2019-09-19 09:00:34.061513	127.0.0.1	\N
59	2019-09-19 11:18:02.331092	127.0.0.1	\N
62	2019-09-19 11:20:02.136757	127.0.0.1	\N
58	2019-09-19 11:29:32.36316	127.0.0.1	\N
57	2019-09-19 11:41:45.450017	127.0.0.1	\N
58	2019-09-20 11:50:11.474702	127.0.0.1	\N
64	2019-09-23 14:29:58.981827	127.0.0.1	\N
57	2019-09-24 13:52:03.184169	127.0.0.1	\N
57	2019-09-24 17:19:13.108613	127.0.0.1	\N
58	2019-09-25 13:21:21.776315	127.0.0.1	\N
59	2019-09-27 10:50:52.585062	127.0.0.1	\N
57	2019-10-04 12:24:01.665605	127.0.0.1	\N
58	2019-10-05 00:41:55.504011	127.0.0.1	\N
57	2019-10-05 08:03:24.238742	127.0.0.1	\N
58	2019-10-05 11:44:00.323625	127.0.0.1	\N
57	2019-10-06 07:39:55.214451	127.0.0.1	\N
58	2019-10-06 14:21:35.702849	127.0.0.1	\N
58	2019-10-08 22:33:56.51113	127.0.0.1	\N
58	2019-10-08 22:35:25.238988	127.0.0.1	\N
57	2019-10-08 22:45:44.377133	127.0.0.1	\N
57	2019-10-08 22:57:51.146447	127.0.0.1	\N
65	2019-10-09 10:18:34.467415	127.0.0.1	\N
57	2019-10-09 17:07:10.319536	127.0.0.1	\N
57	2019-10-09 23:38:55.681467	127.0.0.1	\N
58	2019-10-10 09:41:51.131103	127.0.0.1	\N
64	2019-10-10 12:00:32.027581	127.0.0.1	\N
70	2019-10-10 23:13:20.923992	127.0.0.1	\N
70	2019-10-11 11:42:01.514818	127.0.0.1	\N
57	2019-10-18 00:16:14.010636	127.0.0.1	\N
57	2019-10-20 17:28:45.032897	127.0.0.1	\N
64	2019-10-21 14:44:03.331236	127.0.0.1	\N
70	2019-10-22 11:07:10.057595	127.0.0.1	\N
58	2019-10-24 18:43:58.333894	127.0.0.1	\N
70	2019-10-29 12:29:17.919593	127.0.0.1	\N
57	2019-10-30 21:12:48.816792	127.0.0.1	\N
57	2019-11-01 08:24:43.593237	127.0.0.1	\N
62	2019-11-03 12:16:05.179874	127.0.0.1	\N
65	2019-11-05 14:17:22.775711	127.0.0.1	\N
73	2019-11-07 10:32:34.336442	127.0.0.1	\N
70	2019-11-14 16:42:04.416014	127.0.0.1	\N
\.


--
-- TOC entry 3138 (class 0 OID 0)
-- Dependencies: 199
-- Name: areas_area_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.areas_area_id_seq', 115, true);


--
-- TOC entry 3139 (class 0 OID 0)
-- Dependencies: 201
-- Name: cities_city_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.cities_city_id_seq', 12, true);


--
-- TOC entry 3140 (class 0 OID 0)
-- Dependencies: 209
-- Name: employees_employee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.employees_employee_id_seq', 16, true);


--
-- TOC entry 3141 (class 0 OID 0)
-- Dependencies: 220
-- Name: offices_office_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.offices_office_id_seq', 8, true);


--
-- TOC entry 3142 (class 0 OID 0)
-- Dependencies: 222
-- Name: orders_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.orders_order_id_seq', 1632345784, true);


--
-- TOC entry 3143 (class 0 OID 0)
-- Dependencies: 225
-- Name: shipments_shipment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.shipments_shipment_id_seq', 1923452917, true);


--
-- TOC entry 3144 (class 0 OID 0)
-- Dependencies: 206
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_user_id_seq', 82, true);


--
-- TOC entry 2897 (class 2606 OID 18299)
-- Name: account_types account_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_types
    ADD CONSTRAINT account_types_pkey PRIMARY KEY (account_type_id);


--
-- TOC entry 2899 (class 2606 OID 18301)
-- Name: addresses addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (contact_name, phone, google_place, description, user_id);


--
-- TOC entry 2901 (class 2606 OID 18303)
-- Name: areas areas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.areas
    ADD CONSTRAINT areas_pkey PRIMARY KEY (area_id);


--
-- TOC entry 2903 (class 2606 OID 18305)
-- Name: cities cities_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_name_key UNIQUE (name);


--
-- TOC entry 2905 (class 2606 OID 18307)
-- Name: cities cities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (city_id);


--
-- TOC entry 2907 (class 2606 OID 18309)
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (country_id);


--
-- TOC entry 2915 (class 2606 OID 18317)
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (employee_id);


--
-- TOC entry 2937 (class 2606 OID 18319)
-- Name: offices offices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offices
    ADD CONSTRAINT offices_pkey PRIMARY KEY (office_id);


--
-- TOC entry 2939 (class 2606 OID 18321)
-- Name: orders_history order_history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders_history
    ADD CONSTRAINT order_history_pkey PRIMARY KEY (order_id, order_state_id);


--
-- TOC entry 2917 (class 2606 OID 18323)
-- Name: order_states order_states_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_states
    ADD CONSTRAINT order_states_code_key UNIQUE (code);


--
-- TOC entry 2919 (class 2606 OID 18325)
-- Name: order_states order_states_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_states
    ADD CONSTRAINT order_states_name_key UNIQUE (name);


--
-- TOC entry 2921 (class 2606 OID 18327)
-- Name: order_states order_states_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_states
    ADD CONSTRAINT order_states_pkey PRIMARY KEY (order_state_id);


--
-- TOC entry 2923 (class 2606 OID 18329)
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- TOC entry 2925 (class 2606 OID 18331)
-- Name: payment_options payment_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_options
    ADD CONSTRAINT payment_options_pkey PRIMARY KEY (payment_option_id);


--
-- TOC entry 2941 (class 2606 OID 18333)
-- Name: positions positions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.positions
    ADD CONSTRAINT positions_pkey PRIMARY KEY (position_id);


--
-- TOC entry 2927 (class 2606 OID 18335)
-- Name: shipment_categories shipment_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipment_categories
    ADD CONSTRAINT shipment_categories_pkey PRIMARY KEY (shipment_category_id);


--
-- TOC entry 2931 (class 2606 OID 18337)
-- Name: shipment_states shipment_states_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipment_states
    ADD CONSTRAINT shipment_states_code_key UNIQUE (code);


--
-- TOC entry 2933 (class 2606 OID 18339)
-- Name: shipment_states shipment_states_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipment_states
    ADD CONSTRAINT shipment_states_name_key UNIQUE (name);


--
-- TOC entry 2935 (class 2606 OID 18341)
-- Name: shipment_states shipment_states_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipment_states
    ADD CONSTRAINT shipment_states_pkey PRIMARY KEY (shipment_state_id);


--
-- TOC entry 2929 (class 2606 OID 18343)
-- Name: shipments shipments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT shipments_pkey PRIMARY KEY (shipment_id);


--
-- TOC entry 2909 (class 2606 OID 18311)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 2911 (class 2606 OID 18313)
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- TOC entry 2913 (class 2606 OID 18315)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- TOC entry 2942 (class 2606 OID 18344)
-- Name: addresses addresses_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2943 (class 2606 OID 18349)
-- Name: areas areas_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.areas
    ADD CONSTRAINT areas_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.cities(city_id);


--
-- TOC entry 2944 (class 2606 OID 18359)
-- Name: cities cities_contry_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_contry_id_fkey FOREIGN KEY (country_id) REFERENCES public.countries(country_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2945 (class 2606 OID 18364)
-- Name: cities cities_office_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_office_id_fkey FOREIGN KEY (office_id) REFERENCES public.offices(office_id);


--
-- TOC entry 2951 (class 2606 OID 18384)
-- Name: employees_access_history employees_access_history_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees_access_history
    ADD CONSTRAINT employees_access_history_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(employee_id);


--
-- TOC entry 2949 (class 2606 OID 18389)
-- Name: employees employees_office_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_office_id_fkey FOREIGN KEY (office_id) REFERENCES public.offices(office_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2950 (class 2606 OID 18394)
-- Name: employees employees_position_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_position_id_fkey FOREIGN KEY (position_id) REFERENCES public.positions(position_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2966 (class 2606 OID 18399)
-- Name: offices offices_area_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offices
    ADD CONSTRAINT offices_area_id_fkey FOREIGN KEY (area_id) REFERENCES public.areas(area_id);


--
-- TOC entry 2967 (class 2606 OID 18404)
-- Name: offices offices_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offices
    ADD CONSTRAINT offices_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.cities(city_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2968 (class 2606 OID 18409)
-- Name: offices offices_manager_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offices
    ADD CONSTRAINT offices_manager_id_fkey FOREIGN KEY (manager_id) REFERENCES public.employees(employee_id);


--
-- TOC entry 2969 (class 2606 OID 18414)
-- Name: orders_history order_history_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders_history
    ADD CONSTRAINT order_history_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id);


--
-- TOC entry 2970 (class 2606 OID 18419)
-- Name: orders_history order_history_order_state_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders_history
    ADD CONSTRAINT order_history_order_state_id_fkey FOREIGN KEY (order_state_id) REFERENCES public.order_states(order_state_id);


--
-- TOC entry 2953 (class 2606 OID 18429)
-- Name: orders orders_order_state_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_order_state_id_fkey FOREIGN KEY (order_state_id) REFERENCES public.order_states(order_state_id);


--
-- TOC entry 2954 (class 2606 OID 18434)
-- Name: orders orders_payment_option_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_payment_option_id_fkey FOREIGN KEY (payment_option_id) REFERENCES public.payment_options(payment_option_id);


--
-- TOC entry 2955 (class 2606 OID 18439)
-- Name: orders orders_recipient_area_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_recipient_area_id_fkey FOREIGN KEY (recipient_area_id) REFERENCES public.areas(area_id);


--
-- TOC entry 2956 (class 2606 OID 18444)
-- Name: orders orders_sender_area_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_sender_area_id_fkey FOREIGN KEY (sender_area_id) REFERENCES public.areas(area_id);


--
-- TOC entry 2957 (class 2606 OID 18449)
-- Name: orders orders_shipment_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_shipment_category_id_fkey FOREIGN KEY (shipment_category_id) REFERENCES public.shipment_categories(shipment_category_id);


--
-- TOC entry 2952 (class 2606 OID 18424)
-- Name: orders orders_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2971 (class 2606 OID 18459)
-- Name: shipments_history shipments_history_shipment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipments_history
    ADD CONSTRAINT shipments_history_shipment_id_fkey FOREIGN KEY (shipment_id) REFERENCES public.shipments(shipment_id);


--
-- TOC entry 2959 (class 2606 OID 18464)
-- Name: shipments shipments_office_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT shipments_office_id_fkey FOREIGN KEY (current_office_id) REFERENCES public.offices(office_id);


--
-- TOC entry 2960 (class 2606 OID 18469)
-- Name: shipments shipments_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT shipments_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id);


--
-- TOC entry 2961 (class 2606 OID 18474)
-- Name: shipments shipments_payment_option_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT shipments_payment_option_id_fkey FOREIGN KEY (payment_option_id) REFERENCES public.payment_options(payment_option_id);


--
-- TOC entry 2962 (class 2606 OID 18479)
-- Name: shipments shipments_recipient_area_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT shipments_recipient_area_id_fkey FOREIGN KEY (recipient_area_id) REFERENCES public.areas(area_id);


--
-- TOC entry 2963 (class 2606 OID 18484)
-- Name: shipments shipments_sender_area_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT shipments_sender_area_id_fkey FOREIGN KEY (sender_area_id) REFERENCES public.areas(area_id);


--
-- TOC entry 2964 (class 2606 OID 18489)
-- Name: shipments shipments_shipment_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT shipments_shipment_category_id_fkey FOREIGN KEY (shipment_category_id) REFERENCES public.shipment_categories(shipment_category_id);


--
-- TOC entry 2965 (class 2606 OID 18494)
-- Name: shipments shipments_shipment_state_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT shipments_shipment_state_id_fkey FOREIGN KEY (shipment_state_id) REFERENCES public.shipment_states(shipment_state_id);


--
-- TOC entry 2958 (class 2606 OID 18454)
-- Name: shipments shipments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT shipments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- TOC entry 2972 (class 2606 OID 18499)
-- Name: shipments_history trackings_area_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipments_history
    ADD CONSTRAINT trackings_area_id_fkey FOREIGN KEY (area_id) REFERENCES public.areas(area_id);


--
-- TOC entry 2973 (class 2606 OID 18504)
-- Name: shipments_history trackings_shipment_state_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipments_history
    ADD CONSTRAINT trackings_shipment_state_id_fkey FOREIGN KEY (shipment_state_id) REFERENCES public.shipment_states(shipment_state_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2946 (class 2606 OID 18369)
-- Name: user_updates user_updates_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_updates
    ADD CONSTRAINT user_updates_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- TOC entry 2948 (class 2606 OID 18374)
-- Name: users_access_history users_access_history_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_access_history
    ADD CONSTRAINT users_access_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- TOC entry 2947 (class 2606 OID 18379)
-- Name: users users_account_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_account_type_id_fkey FOREIGN KEY (account_type_id) REFERENCES public.account_types(account_type_id) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2019-11-24 07:00:34 MSK

--
-- PostgreSQL database dump complete
--

