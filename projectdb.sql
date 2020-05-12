--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2
-- Dumped by pg_dump version 12.2

-- Started on 2020-05-07 03:06:58

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

SET default_table_access_method = heap;

--
-- TOC entry 209 (class 1259 OID 19891)
-- Name: offer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.offer (
    id integer NOT NULL,
    name character varying(20) NOT NULL,
    details text,
    price character varying(20) NOT NULL,
    image_file character varying(20) NOT NULL,
    user_id integer NOT NULL,
    date_added timestamp without time zone NOT NULL
);


ALTER TABLE public.offer OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 19889)
-- Name: offer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.offer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.offer_id_seq OWNER TO postgres;

--
-- TOC entry 2891 (class 0 OID 0)
-- Dependencies: 208
-- Name: offer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.offer_id_seq OWNED BY public.offer.id;


--
-- TOC entry 207 (class 1259 OID 19880)
-- Name: product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product (
    id integer NOT NULL,
    name character varying(20) NOT NULL,
    details text,
    image_file character varying(20) NOT NULL,
    bought_price character varying(20) NOT NULL,
    status boolean NOT NULL,
    sold_price character varying(20),
    date_added timestamp without time zone NOT NULL,
    date_sold timestamp without time zone
);


ALTER TABLE public.product OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 19878)
-- Name: product_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_id_seq OWNER TO postgres;

--
-- TOC entry 2892 (class 0 OID 0)
-- Dependencies: 206
-- Name: product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_id_seq OWNED BY public.product.id;


--
-- TOC entry 211 (class 1259 OID 19907)
-- Name: purchase; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchase (
    id integer NOT NULL,
    date_performed timestamp without time zone NOT NULL,
    item_id integer,
    user_id integer,
    seller_id integer
);


ALTER TABLE public.purchase OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 19905)
-- Name: purchase_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.purchase_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.purchase_id_seq OWNER TO postgres;

--
-- TOC entry 2893 (class 0 OID 0)
-- Dependencies: 210
-- Name: purchase_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.purchase_id_seq OWNED BY public.purchase.id;


--
-- TOC entry 213 (class 1259 OID 19930)
-- Name: sale; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sale (
    id integer NOT NULL,
    date_performed timestamp without time zone NOT NULL,
    item_id integer,
    user_id integer,
    seller_id integer
);


ALTER TABLE public.sale OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 19928)
-- Name: sale_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sale_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sale_id_seq OWNER TO postgres;

--
-- TOC entry 2894 (class 0 OID 0)
-- Dependencies: 212
-- Name: sale_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sale_id_seq OWNED BY public.sale.id;


--
-- TOC entry 205 (class 1259 OID 19870)
-- Name: sellers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sellers (
    id integer NOT NULL,
    last_name character varying(30),
    first_name character varying(30) NOT NULL,
    birth date,
    email character varying(120) NOT NULL,
    password character varying(60) NOT NULL
);


ALTER TABLE public.sellers OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 19868)
-- Name: sellers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sellers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sellers_id_seq OWNER TO postgres;

--
-- TOC entry 2895 (class 0 OID 0)
-- Dependencies: 204
-- Name: sellers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sellers_id_seq OWNED BY public.sellers.id;


--
-- TOC entry 203 (class 1259 OID 19860)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    last_name character varying(30) NOT NULL,
    first_name character varying(30) NOT NULL,
    birth date,
    email character varying(120) NOT NULL,
    password character varying(60) NOT NULL,
    ship_address character varying(120),
    status boolean
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 19858)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 2896 (class 0 OID 0)
-- Dependencies: 202
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 2722 (class 2604 OID 19894)
-- Name: offer id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.offer ALTER COLUMN id SET DEFAULT nextval('public.offer_id_seq'::regclass);


--
-- TOC entry 2721 (class 2604 OID 19883)
-- Name: product id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product ALTER COLUMN id SET DEFAULT nextval('public.product_id_seq'::regclass);


--
-- TOC entry 2723 (class 2604 OID 19910)
-- Name: purchase id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase ALTER COLUMN id SET DEFAULT nextval('public.purchase_id_seq'::regclass);


--
-- TOC entry 2724 (class 2604 OID 19933)
-- Name: sale id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sale ALTER COLUMN id SET DEFAULT nextval('public.sale_id_seq'::regclass);


--
-- TOC entry 2720 (class 2604 OID 19873)
-- Name: sellers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sellers ALTER COLUMN id SET DEFAULT nextval('public.sellers_id_seq'::regclass);


--
-- TOC entry 2719 (class 2604 OID 19863)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 2881 (class 0 OID 19891)
-- Dependencies: 209
-- Data for Name: offer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.offer (id, name, details, price, image_file, user_id, date_added) FROM stdin;
1	Chicken	Very good chicken alive	12	47255d39896ec39b.jpg	3	2020-05-06 23:29:21.011842
3	Door	Height: 2m\\r\\nWidth: 2m	300	a28469b5dacf9402.jpg	3	2020-05-06 23:33:10.873079
14	Shield	Old round metal medieval shield	200	c4b5c34d1526429b.jpg	3	2020-05-07 00:02:42.163725
\.


--
-- TOC entry 2879 (class 0 OID 19880)
-- Dependencies: 207
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product (id, name, details, image_file, bought_price, status, sold_price, date_added, date_sold) FROM stdin;
6	Laptop	Very good laptop	1ab46e609e5d81ab.jpg	20000	t	22000	2020-05-06 23:54:10.714045	\N
5	Refrigerator	Freeeeezing cold	b4b4590fd851d36f.jpg	12000	t	17000	2020-05-06 23:54:06.9812	\N
4	Crown	Elizabeth's crown	0c8a837a7fbcc639.png	50000	t	200000	2020-05-06 23:54:02.989992	2020-05-06 23:58:21.423484
2	Violin	Very interesting rare shaped old violin 	c058170ca69d4ac8.jpg	10	t	20000	2020-05-06 23:53:26.391042	2020-05-06 23:58:29.585988
3	Watch	RARE Antique OMEGA Pocket Watch SWISS Vintage Open Face	ac855edc22a48fb1.jpg	100	t	1000	2020-05-06 23:53:32.755036	2020-05-06 23:58:39.38476
1	Pistol	Pistol gun old weapon metal collectible	998dd294b9b2af69.jpg	2000	t	9000	2020-05-06 23:53:21.503168	2020-05-07 00:00:27.749312
7	Lamp	Bright lamp	3480fe69b775839a.jpg	30	f	\N	2020-05-07 00:03:13.096353	\N
\.


--
-- TOC entry 2883 (class 0 OID 19907)
-- Dependencies: 211
-- Data for Name: purchase; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.purchase (id, date_performed, item_id, user_id, seller_id) FROM stdin;
1	2020-05-06 23:53:21.530138	1	3	1
2	2020-05-06 23:53:26.411788	2	3	1
3	2020-05-06 23:53:32.778927	3	3	1
4	2020-05-06 23:54:03.015239	4	3	2
5	2020-05-06 23:54:07.004092	5	3	2
6	2020-05-06 23:54:10.742792	6	3	2
7	2020-05-07 00:03:13.117104	7	3	2
\.


--
-- TOC entry 2885 (class 0 OID 19930)
-- Dependencies: 213
-- Data for Name: sale; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sale (id, date_performed, item_id, user_id, seller_id) FROM stdin;
1	2020-05-06 23:58:21.452696	4	3	2
2	2020-05-06 23:58:29.609767	2	3	1
3	2020-05-06 23:58:39.407605	3	3	1
4	2020-05-07 00:00:27.774669	1	3	1
\.


--
-- TOC entry 2877 (class 0 OID 19870)
-- Dependencies: 205
-- Data for Name: sellers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sellers (id, last_name, first_name, birth, email, password) FROM stdin;
\.


--
-- TOC entry 2875 (class 0 OID 19860)
-- Dependencies: 203
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, last_name, first_name, birth, email, password, ship_address, status) FROM stdin;
3	Doe	John	1953-02-25	john.doe@example.com	$2b$12$CFEM2PasNjVGwtUqgV3zM.vetM7bAw0Vi9VYp3Ik2tBfsWgT4Kvm2	123 Main St Anytown, USA	f
2	Odinson	Thor	0964-02-02	thor@starkenterprises.com	$2b$12$AtfTcE/ED8tyY98kpTE.LOWdSfKTfmUPf0MbTu.LNKqrrshrZaWXy	Asgard	t
1	Stark	Anthony	1970-05-29	tony@starkenterprises.com	$2b$12$pB6UpViIH.LJpTjJTlOgYeuOyjBwh8UGIQQLJtwCFo.tv1BsS6qz6	10880 Malibu Point, 90265	t
\.


--
-- TOC entry 2897 (class 0 OID 0)
-- Dependencies: 208
-- Name: offer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.offer_id_seq', 14, true);


--
-- TOC entry 2898 (class 0 OID 0)
-- Dependencies: 206
-- Name: product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_id_seq', 7, true);


--
-- TOC entry 2899 (class 0 OID 0)
-- Dependencies: 210
-- Name: purchase_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.purchase_id_seq', 7, true);


--
-- TOC entry 2900 (class 0 OID 0)
-- Dependencies: 212
-- Name: sale_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sale_id_seq', 4, true);


--
-- TOC entry 2901 (class 0 OID 0)
-- Dependencies: 204
-- Name: sellers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sellers_id_seq', 1, false);


--
-- TOC entry 2902 (class 0 OID 0)
-- Dependencies: 202
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 3, true);


--
-- TOC entry 2736 (class 2606 OID 19899)
-- Name: offer offer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.offer
    ADD CONSTRAINT offer_pkey PRIMARY KEY (id);


--
-- TOC entry 2734 (class 2606 OID 19888)
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);


--
-- TOC entry 2738 (class 2606 OID 19912)
-- Name: purchase purchase_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase
    ADD CONSTRAINT purchase_pkey PRIMARY KEY (id);


--
-- TOC entry 2740 (class 2606 OID 19935)
-- Name: sale sale_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sale
    ADD CONSTRAINT sale_pkey PRIMARY KEY (id);


--
-- TOC entry 2730 (class 2606 OID 19877)
-- Name: sellers sellers_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sellers
    ADD CONSTRAINT sellers_email_key UNIQUE (email);


--
-- TOC entry 2732 (class 2606 OID 19875)
-- Name: sellers sellers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sellers
    ADD CONSTRAINT sellers_pkey PRIMARY KEY (id);


--
-- TOC entry 2726 (class 2606 OID 19867)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 2728 (class 2606 OID 19865)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 2741 (class 2606 OID 19900)
-- Name: offer offer_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.offer
    ADD CONSTRAINT offer_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 2742 (class 2606 OID 19913)
-- Name: purchase purchase_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase
    ADD CONSTRAINT purchase_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.product(id);


--
-- TOC entry 2744 (class 2606 OID 19923)
-- Name: purchase purchase_seller_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase
    ADD CONSTRAINT purchase_seller_id_fkey FOREIGN KEY (seller_id) REFERENCES public.users(id);


--
-- TOC entry 2743 (class 2606 OID 19918)
-- Name: purchase purchase_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase
    ADD CONSTRAINT purchase_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 2745 (class 2606 OID 19936)
-- Name: sale sale_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sale
    ADD CONSTRAINT sale_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.product(id);


--
-- TOC entry 2747 (class 2606 OID 19946)
-- Name: sale sale_seller_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sale
    ADD CONSTRAINT sale_seller_id_fkey FOREIGN KEY (seller_id) REFERENCES public.users(id);


--
-- TOC entry 2746 (class 2606 OID 19941)
-- Name: sale sale_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sale
    ADD CONSTRAINT sale_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


-- Completed on 2020-05-07 03:06:59

--
-- PostgreSQL database dump complete
--

