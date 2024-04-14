import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class SubjectController extends GetxController {
  static SubjectController get to => Get.find();

  List subjects = [];
  RxInt subject_id = 0.obs;
  RxString subject = ''.obs;
  // RxString todaySubject = ''.obs;
  RxString mmdd_yoil = ''.obs;
  String mmdd = '';
  String subject_diary_id = '';
  String content = '';
  String comment = '';
  RxString active_screen = 'diary'.obs;
  RxString dummy_date = DateTime.now().toString().obs;
  RxBool is_subject_comment = true.obs;
  RxDouble subject_full_screen_text_size = 40.0.obs;

  @override
  void onInit() async {

    // await updSubjects();

    // var mmdd = DateTime.now().month.toString().padLeft(2,'0') + DateTime.now().day.toString().padLeft(2,'0');
    // await getInitPage(mmdd);
  }

  /// 댓글허용
  // Future<void> updCommentAllow() async{
  //   await FirebaseFirestore.instance.collection('class_info').where('class_code', isEqualTo: GetStorage().read('class_code'))
  //       .get().then((QuerySnapshot snapshot) async {
  //     if (snapshot.docs.length > 0) {
  //       await FirebaseFirestore.instance.collection('class_info').doc(snapshot.docs.first.id).update({ 'subject_comment': is_subject_comment.value });
  //     }
  //   });
  // }

  Future<void> saveSubject() async{
    await FirebaseFirestore.instance.collection('subject_list').where('class_code', isEqualTo: GetStorage().read('class_code'))
        .where('id', isEqualTo: subject_id.value).get().then((QuerySnapshot snapshot) async {
      if (snapshot.docs.length > 0) {
        await FirebaseFirestore.instance.collection('subject_list').doc(snapshot.docs.first.id).update({ 'subject': subject.value });
      }else {
        await FirebaseFirestore.instance.collection('subject_list').add({'class_code': GetStorage().read('class_code'), 'id': subject_id.value, 'mmdd': mmdd,  'subject': subject.value });
      }
    });
  }

  Future<void> getSubjects() async{
    subjects = [
      Subject(0,'0101','나의 새해 목표'),
      Subject(1,'0102','나의 매력포인트'),
      Subject(2,'0103','나에게 100만원이 생긴다면'),
      Subject(3,'0104','요술램프가 있다면 세가지 소원은'),
      Subject(4,'0105','마지막으로 성취감을 느꼈을 때'),
      Subject(5,'0106','요즘 나를 설레게 하는 것'),
      Subject(6,'0107','요즘 즐겨먹는 음식'),
      Subject(7,'0108','내가 살고 싶은 집'),
      Subject(8,'0109','아침에 눈 뜨자마자 한 행동은'),
      Subject(9,'0110','기억에 남는 어린 시절 경험은?'),
      Subject(10,'0111','마지막으로 새로운 것을 시도했을 때'),
      Subject(11,'0112','최근에 꾼 꿈'),
      Subject(12,'0113','가장 좋아하는 취미'),
      Subject(13,'0114','마지막으로 주체할 수 없이 웃었던 적'),
      Subject(14,'0115','배우고 싶은 기술'),
      Subject(15,'0116','세상에서 가장 좋아하는 장소'),
      Subject(16,'0117','나에게 영감을 주는 사람'),
      Subject(17,'0118','최근에 배운 인생교훈'),
      Subject(18,'0119','가장 행복했던 기억'),
      Subject(19,'0120','여행가고 싶은 곳'),
      Subject(20,'0121','마지막으로 울었던 기억'),
      Subject(21,'0122','목격했거나 행한 친절에 대한 기억'),
      Subject(22,'0123','날씨가 추워지면 떠오르는 사람이나 사연'),
      Subject(23,'0124','마지막으로 자랑스러워했던 때'),
      Subject(24,'0125','최근에 한 실수'),
      Subject(25,'0126','제일 좋아하는 노래'),
      Subject(26,'0127','감사함을 느꼈던 순간'),
      Subject(27,'0128','가장 좋아하는 휴식 방법'),
      Subject(28,'0129','나의 가장 큰 성취'),
      Subject(29,'0130','나에게 영감을 주는 명언'),
      Subject(30,'0131','나의 주량과 술버릇'),
      Subject(31,'0201','가장 좋아하는 어린 시절의 기억'),
      Subject(32,'0202','가장 좋아하는 TV 쇼'),
      Subject(33,'0203','내 인생을 바꾼 순간'),
      Subject(34,'0204','마음이 평화로워지는 곳'),
      Subject(35,'0205','가장 좋아하는 야외 활동'),
      Subject(36,'0206','힘든 경험을 통해 얻은 교훈'),
      Subject(37,'0207','좋아하는 날씨 유형'),
      Subject(38,'0208','내 인생에 변화를 준 사람'),
      Subject(39,'0209','가장 좋아하는 동물'),
      Subject(40,'0210','마지막으로 뭔가에 대해 정말 흥분했을 때'),
      Subject(41,'0211','도움이 필요한 사람을 도왔던 적'),
      Subject(42,'0212','아침에 눈 뜨자마자 한 행동은'),
      Subject(43,'0213','좋아하는 색'),
      Subject(44,'0214','마지막으로 새로운 것을 배웠을 때'),
      Subject(45,'0215','좋아하는 어린 시절 장난감'),
      Subject(46,'0216','추억을 되살리는 노래'),
      Subject(47,'0217','아침에 눈 뜨자마자 한 행동은'),
      Subject(48,'0218','시련을 이겨낸 시간'),
      Subject(49,'0219','가장 좋아하는 독서 장소'),
      Subject(50,'0220','그리운 사람'),
      Subject(51,'0221','용감했던 순간'),
      Subject(52,'0222','오늘 나를 웃게 한 순간'),
      Subject(53,'0223','좋아하는 디저트 종류'),
      Subject(54,'0224','나른한 하루를 보내는 좋은 방법'),
      Subject(55,'0225','마지막으로 행복하다고 느꼈을 때'),
      Subject(56,'0226','언젠가는 살고 싶은 곳'),
      Subject(57,'0227','좋아하는 요리 종류'),
      Subject(58,'0228','나의 장단점은'),
      Subject(59,'0229','윤년, 윤달이 뭔지 아니'),
      Subject(60,'0301','나라를 위해 돌아가신 분을 얼마나 알고 있나요'),
      Subject(61,'0302','나에게 가장 소중한 것과 이유'),
      Subject(62,'0303','이 세상에 꼭 필요한 것과 이유'),
      Subject(63,'0304','내 묘비에 쓰고 싶은 말'),
      Subject(64,'0305','비행기를 타고 가고 싶은 곳은'),
      Subject(65,'0306','타임머신을 타고 가고 싶은 곳은?'),
      Subject(66,'0307','오늘 내가 들은 말 중 가장 기억에 남는 말'),
      Subject(67,'0308','내 성격의 단점 5가지'),
      Subject(68,'0309','나의 마음을 다치게 했던 다른 사람의 말과 행동'),
      Subject(69,'0310','내가 투명 인간이라면'),
      Subject(70,'0311','어른이 된다면 하고 싶은 일'),
      Subject(71,'0312','내가 키우고 싶은 동물'),
      Subject(72,'0313','아침에 눈 뜨자마자 한 행동은'),
      Subject(73,'0314','우리 부모님의 좋은 점은'),
      Subject(74,'0315','산타가 된다면 누구에게 무슨 선물을 주고 싶은가?'),
      Subject(75,'0316','기분이 좋았던 꿈이야기'),
      Subject(76,'0317','내가 가장 좋아하는 음식은'),
      Subject(77,'0318','태어나자마자 아기가 말을 한다면?'),
      Subject(78,'0319','다섯 쌍둥이를 낳았다. 이름은?'),
      Subject(79,'0320','인류 역사상 가장 위대한 발명품은'),
      Subject(80,'0321','대통령이 된다면 하고 싶은 일'),
      Subject(81,'0322','세상에서 가장 아름다운 말'),
      Subject(82,'0323','내가 얻고 싶은 초능력은?'),
      Subject(83,'0324','애국가 1절~4절 적어보기'),
      Subject(84,'0325','내 짝꿍 칭찬하기'),
      Subject(85,'0326','똥을 쌌는데 휴지가 없다'),
      Subject(86,'0327','순간이동이 딱 한번 가능하다면 가고 싶은 곳'),
      Subject(87,'0328','날개가 있으면 편한 점과 불편한 점'),
      Subject(88,'0329','저승사자가 나를 데리러 왔다. 따돌릴 계획을 세워라'),
      Subject(89,'0330','무지개의 끝에는 무엇이 있을까'),
      Subject(90,'0331','맑은 날 우산으로 할 수 있는 일'),
      Subject(91,'0401','자고 일어나니 벚꽃이 활짝 피었다'),
      Subject(92,'0402','영화관에서 할 수 있는 가장 매너 없는 행동'),
      Subject(93,'0403','제주 4.3항쟁을 아는가'),
      Subject(94,'0404','통일은 과연 우리에게 도움이 되는가'),
      Subject(95,'0405','안경을 쓰면 좋은점과 나쁜점'),
      Subject(96,'0406','가위,소금,버스,고양이가 들어가게 이야기를 써라'),
      Subject(97,'0407','이 세상에서 사라져야할 것'),
      Subject(98,'0408','하루종일 체육시간이라면 하고 싶은 것'),
      Subject(99,'0409','내가 멋있게 보였던 순간'),
      Subject(100,'0410','나에게 스트레스를 주는 것'),
      Subject(101,'0411','가장 재미있게 읽은 책 소개하기'),
      Subject(102,'0412','시간을 멈추고 싶은 순간이 있다면?'),
      Subject(103,'0413','배우고 싶은 악기가 있다면?'),
      Subject(104,'0414','올해 생일에 받고 싶은 선물'),
      Subject(105,'0415','아침에 눈 뜨자마자 한 행동은'),
      Subject(106,'0416','학교에서 집까지 가는 길에 보이는 것들'),
      Subject(107,'0417','가장 재미있었던 영화'),
      Subject(108,'0418','나에게 돈이란'),
      Subject(109,'0419','봄나들이로 사생시 짓기'),
      Subject(110,'0420','가장 좋아하는 과자 자세히 설명하기'),
      Subject(111,'0421','우리반의 장점 3가지'),
      Subject(112,'0422','아침에 무엇을 먹었나'),
      Subject(113,'0423','고양이를 키우는가'),
      Subject(114,'0424','최근에 본 영화는'),
      Subject(115,'0425','코끼리를 냉장고에 넣는 방법'),
      Subject(116,'0426','내가 즐겨보는 유튜브 채널은'),
      Subject(117,'0427','오늘 부모님을 위해 할 수 있는 일'),
      Subject(118,'0428','국내여행 어디까지 가보았나요'),
      Subject(119,'0429','오늘 몇걸음 걸었는가'),
      Subject(120,'0430','내 방에 있었으면 하는 물건'),
      Subject(121,'0501','오늘 하늘 자세히 묘사하기'),
      Subject(122,'0502','우주에는 별이 얼마나 될까'),
      Subject(123,'0503','우주는 끝이 있을까'),
      Subject(124,'0504','오늘 본 꽃 자세히 묘사하기'),
      Subject(125,'0505','외계인을 만나면 하고 싶은 것'),
      Subject(126,'0506','건강을 위해 하는 것들'),
      Subject(127,'0507','눈이 녹으면'),
      Subject(128,'0508','어떤 어른이 되고 싶나요'),
      Subject(129,'0509','들으면 기분이 좋아지는 말'),
      Subject(130,'0510','다른 사람이 될 수 있다면 누가 되고 싶나요'),
      Subject(131,'0511','길을 가다 금덩어리를 발견한다면'),
      Subject(132,'0512','금요일이 기다려지는 이유'),
      Subject(133,'0513','내 삶에서 지우고 싶은 순간'),
      Subject(134,'0514','어머니는 어떤 분인가요'),
      Subject(135,'0515','아버지는 어떤 분인가요'),
      Subject(136,'0516','내가 좋아하는 단어'),
      Subject(137,'0517','내가 생각하는 좋은 친구의 조건 3가지'),
      Subject(138,'0518','날개가 있다면 하고 싶은 것'),
      Subject(139,'0519','담임선생님이 된다면 하고 싶은 것'),
      Subject(140,'0520','자고 일어나니 돼지가 되었다'),
      Subject(141,'0521','아침에 눈 뜨자마자 한 행동은'),
      Subject(142,'0522','야외에서 음료를 마시고 쓰레기통이 안보인다면'),
      Subject(143,'0523','지구환경보호를 위해 내가 할 수 있는 것은'),
      Subject(144,'0524','눈을 떠보니 내가 공원 벤치에 누워있었다'),
      Subject(145,'0525','모기에게 협박편지를 써라'),
      Subject(146,'0526','요즘 나의 하루를 자세히 설명하기'),
      Subject(147,'0527','얼마전에 먹었던 치킨(닭)의 인생'),
      Subject(148,'0528','내가 가장 좋아하는 과목은'),
      Subject(149,'0529','냉동인간이 되어 500년 후에 깨어난 세상은'),
      Subject(150,'0530','아프리카에서 난로를 팔 수 있는 방법'),
      Subject(151,'0531','무인도에 꼭 가져가고 싶은 물건 3가지'),
      Subject(152,'0601','가장 좋아하는 TV 프로그램'),
      Subject(153,'0602','짜장 VS 짬뽕'),
      Subject(154,'0603','화를 잠 재우는 나만의 방법'),
      Subject(155,'0604','아낌없이 주는 나무의 행동에 대해 어떻게 생각해'),
      Subject(156,'0605','자주 부르거나 듣는 노래'),
      Subject(157,'0606','어떤 로봇(AI)가 등장하면 좋을까'),
      Subject(158,'0607','어제 한번이라도 말을 걸어 본 친구들은'),
      Subject(159,'0608','가장 최근에 들은 노래 제목은'),
      Subject(160,'0609','영화나 드라마를 보고 울어본 기억은'),
      Subject(161,'0610','동물원은 꼭 필요할까'),
      Subject(162,'0611','죽기전에 해보고 싶은 활동 버킷리스트'),
      Subject(163,'0612','빨간불인데 차가 안보인다. 횡단보도를 건널것인가'),
      Subject(164,'0613','지금 먹고 싶은것은'),
      Subject(165,'0614','부모님을 웃겨 본 적은'),
      Subject(166,'0615','이런 과자가 있었으면 좋겠다'),
      Subject(167,'0616','요즘 춤을 춰 본 적 있나요'),
      Subject(168,'0617','가장 존경하는 사람 소개하기'),
      Subject(169,'0618','토끼가 거북이를 깨우지 않은 것은 옳은 행동인가요'),
      Subject(170,'0619','가장 좋아하는 과일과 이유'),
      Subject(171,'0620','좋아하는 게임은 무엇'),
      Subject(172,'0621','어린이의 연예계 진출의 좋은 점, 나쁜 점'),
      Subject(173,'0622','잠들기 전에 가장 많이 하는 생각은'),
      Subject(174,'0623','가족과 좀더 가까워 지려면 어떻게 하면 좋을까'),
      Subject(175,'0624','피노키오는 사람일까 인형일까'),
      Subject(176,'0625','현재 종교,이념,경제등 여러문제로 분쟁중인 나라는'),
      Subject(177,'0626','귀신은 존재할까'),
      Subject(178,'0627','최근에 손을 잡아본 적 있는가'),
      Subject(179,'0628','가장 기억에 남는 밤은'),
      Subject(180,'0629','이거 사주세요.....제발'),
      Subject(181,'0630','가장 기억에 남는 여행이나 추억'),
      Subject(182,'0701','마음의 평온을 찾는 나만의 방법은'),
      Subject(183,'0702','스마트폰으로 가장 많이 하는 것은'),
      Subject(184,'0703','내가 아는 우리나라 역사적 인물 많이 적어보기'),
      Subject(185,'0704','채식만 하는것을 어떻게 생각해'),
      Subject(186,'0705','용돈은 어떻게 받아'),
      Subject(187,'0706','여름방학에 뭐 하고 싶어'),
      Subject(188,'0707','사형제 찬성 VS 반대'),
      Subject(189,'0708','오늘 날씨는 어떤지 구체적으로'),
      Subject(190,'0709','눈을 감고 그려지는 바다의 풍경을 묘사해보자'),
      Subject(191,'0710','자서전을 쓴다면 첫 문장을 어떻게 시작할까'),
      Subject(192,'0711','눈을 떠보니 내 옆에 낯선 남자(여자)가 누워있다면'),
      Subject(193,'0712','시간이 지나도 변하지 않는 것은'),
      Subject(194,'0713','나의 MBTI'),
      Subject(195,'0714','마트에서 꼭 사는 물건은'),
      Subject(196,'0715','지금 보고 싶은 사람이 SNRN'),
      Subject(197,'0716','우리 사회는 정의로운가'),
      Subject(198,'0717','용변은 잘 보니'),
      Subject(199,'0718','유기동물의 안락사를 어떻게 생각해'),
      Subject(200,'0719','아침에 눈 뜨자마자 한 행동은'),
      Subject(201,'0720','좋아하는 시를 적어보자'),
      Subject(202,'0721','오늘 일기를 영어로 적어보자'),
      Subject(203,'0722','우리 부모님은 요즘 어떤 걱정을 하나'),
      Subject(204,'0723','요즘 즐겨 듣는 노래는'),
      Subject(205,'0724','누군가가 나를 위해 무언가를 직접 만들어준 적은'),
      Subject(206,'0725','보신탕은 먹어도 되나'),
      Subject(207,'0726','물건을 고를 때 가장 우선적으로 생각하는 것은'),
      Subject(208,'0727','좋아하는 과일은 무엇인가'),
      Subject(209,'0728','자다가 배가 아파서 깨어본 적 있니'),
      Subject(210,'0729','미래의 여자(남자)친구는 이랬으면 좋겠다'),
      Subject(211,'0730','올해 처음 산 선물은'),
      Subject(212,'0731','일요일 오후가 되면 어떤 기분이 드니'),
      Subject(213,'0801','외계인은 존재할까'),
      Subject(214,'0802','최근에 손을 잡아 본 사람이 있는가'),
      Subject(215,'0803','어제는 무엇을 했니'),
      Subject(216,'0804','사랑이란 뭘까'),
      Subject(217,'0805','운동을 하다 크게 다쳐본 적은'),
      Subject(218,'0806','커피 맛이 어때'),
      Subject(219,'0807','기억에 남는 명대사는'),
      Subject(220,'0808','지금 보고싶은 사람이 있는가'),
      Subject(221,'0809','신은 존재할까'),
      Subject(222,'0810','내일 지구가 멸망한다면'),
      Subject(223,'0811','오늘 가장 즐거웠던 순간은'),
      Subject(224,'0812','학원은 다녀야 하는가'),
      Subject(225,'0813','좋은 습관을 가지려고 노력하니'),
      Subject(226,'0814','두번이상 본 책은'),
      Subject(227,'0815','오늘은 광복절. 떠오르는 인물은'),
      Subject(228,'0816','눈치를 많이 보는 편이니'),
      Subject(229,'0817','처음으로 안아본 포옹은'),
      Subject(230,'0818','나의 태몽은 무엇'),
      Subject(231,'0819','내 이름으로 삼행시 지어 보기'),
      Subject(232,'0820','연예인의 사생활은 공개되어야 하나'),
      Subject(233,'0821','나는 일본을 이렇게 생각한다'),
      Subject(234,'0822','시를 한편 적어보자'),
      Subject(235,'0823','부모님이 좋아하는 음식은'),
      Subject(236,'0824','요즘 마음에 드는 영화(드라마) 명대사가 있나'),
      Subject(237,'0825','이민 가고 싶은 나라는'),
      Subject(238,'0826','최근에 읽은 책은'),
      Subject(239,'0827','10년뒤에 나는 무엇을 하고 있을까'),
      Subject(240,'0828','더위를 이겨내는 나만의 방법'),
      Subject(241,'0829','스포츠 경기를 마지막으로 관람한 적은 언제'),
      Subject(242,'0830','10억을 받고 아무도 없는 무인도에서 1년 살 수 있나'),
      Subject(243,'0831','아침에 눈 뜨자마자 한 행동은'),
      Subject(244,'0901','시를 한편 적어보자'),
      Subject(245,'0902','요즘 내가 가장 관심있는 것'),
      Subject(246,'0903','내가 정말 참기 힘든 것은'),
      Subject(247,'0904','지금 정말 가고 싶은 곳은'),
      Subject(248,'0905','20년후의 나의 모습은 어떨까'),
      Subject(249,'0906','거울에 비친 나의 모습이 어때'),
      Subject(250,'0907','자서전을 쓴다면 첫 문장은 어떻게 시작할까'),
      Subject(251,'0908','범죄자의 신상을 공개해도 되나'),
      Subject(252,'0909','화 다스리는 법'),
      Subject(253,'0910','가장 기억에 남는 영화는 무엇인가'),
      Subject(254,'0911','존경하는 인물은'),
      Subject(255,'0912','노래방을 언제 가보았나'),
      Subject(256,'0913','운이 좋았다고 느꼈던 적은'),
      Subject(257,'0914','구름을 주제로 짧은 시 적어보기'),
      Subject(258,'0915','스마트폰에 있었으면 하는 기능은'),
      Subject(259,'0916','1년뒤 나에게 보내는 편지'),
      Subject(260,'0917','어릴 적 사진을 보면 어떤 생각이 들어'),
      Subject(261,'0918','남들이 믿지 않아 억울했던 적은'),
      Subject(262,'0919','요즘 환경이 심하게 오염되었다고 느낄때'),
      Subject(263,'0920','남들은 모르는 나만의 재능'),
      Subject(264,'0921','내가 태어났때 우리 부모님의 반응'),
      Subject(265,'0922','중국하면 떠오르는 것'),
      Subject(266,'0923','돈이 많으면 행복할까'),
      Subject(267,'0924','심심할때 시간을 보내는 나만의 방법'),
      Subject(268,'0925','황금똥을 누기위한 나만의 방법은'),
      Subject(269,'0926','어떤 스타일의 옷을 선호하니'),
      Subject(270,'0927','나는 강아지보다 고양이가 좋다'),
      Subject(271,'0928','나는 부모님의 어떤 점을 닮았을까'),
      Subject(272,'0929','죽기전에 가보고 싶은 장소 버킷리스트'),
      Subject(273,'0930','가장 서러웠던 적은'),
      Subject(274,'1001','통지표에 이런 말이 적혔으면 좋겠다'),
      Subject(275,'1002','아침에 비가 오면 어떤 기분이 드니'),
      Subject(276,'1003','친구, 고릴라, 김치를 넣어서 세 문장이상 적어보기'),
      Subject(277,'1004','다시 1학년으로 돌아간다면'),
      Subject(278,'1005','우리집에서 가장 더러운 곳'),
      Subject(279,'1006','수업시간에 자장면을 먹는 방법'),
      Subject(280,'1007','요즘 가장 신경쓰이는 사람은'),
      Subject(281,'1008','양심의 가책을 느낀 적이 있다면'),
      Subject(282,'1009','내가 좋아하는 사람들의 공통점'),
      Subject(283,'1010','엄마가 좋아하는 것'),
      Subject(284,'1011','아빠가 좋아하는 것'),
      Subject(285,'1012','실수든 아니든 생명을 죽여본 적 있니'),
      Subject(286,'1013','해 보고 싶은 봉사활동'),
      Subject(287,'1014','동물을 좋아하니'),
      Subject(288,'1015','반드시 학교는 가야하는 이유 설명해보기'),
      Subject(289,'1016','내가 경험한 가장 더웠던/추웠던 경험 적어보기'),
      Subject(290,'1017','좋아하는 계절'),
      Subject(291,'1018','요즘 부모님이 자주 나에게 하는 말(잔소리)'),
      Subject(292,'1019','가장 행복했던 순간'),
      Subject(293,'1020','밤을 새워 읽은 책(게임, 유튜브,영화)는'),
      Subject(294,'1021','내가 못먹는 음식은'),
      Subject(295,'1022','내년에 이루고 싶은 목표'),
      Subject(296,'1023','요즘 사고 싶은 물건'),
      Subject(297,'1024','버리고 싶은 나의 습관은'),
      Subject(298,'1025','만약 유튜버라면 어떤 방송을 하고 싶은가'),
      Subject(299,'1026','이번 주말에 가고 싶은 곳'),
      Subject(300,'1027','부모님과 여행을 가본 곳은'),
      Subject(301,'1028','물에 빠진 사람을 보면 어떻게 해야 하나'),
      Subject(302,'1029','나라를 위해 할 수 있는 일 3가지 적어보기'),
      Subject(303,'1030','월요병을 이겨내는 나만의 방법'),
      Subject(304,'1031','우리나라에서 핼러윈을 즐기는 것을 어떻게 생각하니'),
      Subject(305,'1101','10초동안 보았던 것을 모두 적어보자'),
      Subject(306,'1102','내가 했던 최고의 민폐'),
      Subject(307,'1103','마라탕을 좋아하니'),
      Subject(308,'1104','고기류는 어떤 종류를 즐겨먹니'),
      Subject(309,'1105','승부욕에 불 타오른 적이 있다면'),
      Subject(310,'1106','미국하면 떠오른 것'),
      Subject(311,'1107','우정이란'),
      Subject(312,'1108','죽음에 대해 생각해 본 적 있니'),
      Subject(313,'1109','대통령에게 바라는 것'),
      Subject(314,'1110','마음에 드는 노랫말은'),
      Subject(315,'1111','시를 한편 적어보자'),
      Subject(316,'1112','사람과 사는 고양이는 행복할까'),
      Subject(317,'1113','요즘 핫한 유튜브 숏츠는?'),
      Subject(318,'1114','혼자 일때 편안함을 느낀 적은'),
      Subject(319,'1115','산 VS 바다'),
      Subject(320,'1116','실험용으로 동물을 사용하는 것은 옳은가'),
      Subject(321,'1117','살면서 가장 소중하게 여기는 것은'),
      Subject(322,'1118','좋아하는 스포츠'),
      Subject(323,'1119','내가 싫어하는 과목'),
      Subject(324,'1120','요즘 배우고 싶은 것'),
      Subject(325,'1121','내 주위에 본받고 싶은 시람'),
      Subject(326,'1122','갖고 싶은 습관은'),
      Subject(327,'1123','최근에 경험한 사고는'),
      Subject(328,'1124','나는 OO없이는 못산다'),
      Subject(329,'1125','겨울방학때 하고 싶은 것'),
      Subject(330,'1126','친일파에게 보내는 분노의 편지'),
      Subject(331,'1127','죽기전에 먹어 보고 싶은 음식 버킷리스트'),
      Subject(332,'1128','토요일 아침 눈이 소복이 쌓여 있다'),
      Subject(333,'1129','최근에 본 영화(드라마)는'),
      Subject(334,'1130','키우고 싶은 반려동물이 있는가'),
      Subject(335,'1201','올해 가장 후회되는 일은'),
      Subject(336,'1202','내가 가장 소중하게 여기는 물건은'),
      Subject(337,'1203','첫눈이 오면'),
      Subject(338,'1204','기부는 해보았니'),
      Subject(339,'1205','여름 VS 겨울'),
      Subject(340,'1206','가난한 사람을 돕기 위해 홍길동이 한 행동은 정당한가'),
      Subject(341,'1207','금요일 저녁에는 주로 뭘 하니'),
      Subject(342,'1208','최근에 가 본 공연장은'),
      Subject(343,'1209','최근에 타인에게 도움을 준 적은'),
      Subject(344,'1210','가장 심하게 아팠던 경험'),
      Subject(345,'1211','탕후루를 좋아하니'),
      Subject(346,'1212','잠은 몇시에 자니'),
      Subject(347,'1213','올해 가장 잘한 일은'),
      Subject(348,'1214','최근에 산 가장 비싼 것은'),
      Subject(349,'1215','내가 잘하는 것 3가지'),
      Subject(350,'1216','가족중 한 사람의 관찰일기 적어보기'),
      Subject(351,'1217','심청이는 효녀인가'),
      Subject(352,'1218','길거리에서 꼴불견인 행동'),
      Subject(353,'1219','가장 좋아하는 케이크의 종류'),
      Subject(354,'1220','아침에 눈 뜨자마자 한 행동은'),
      Subject(355,'1221','가장 기억에 남는 친구'),
      Subject(356,'1222','부모님이 좋아하는 노래는'),
      Subject(357,'1223','급식을 남기는 나만의 노하우'),
      Subject(358,'1224','불 꺼진 방에서 촛불을 바라보면 드는 생각'),
      Subject(359,'1225','크리스마스! 어떻게 하루를 보낼까'),
      Subject(360,'1226','올해 가장 후회되는 일은'),
      Subject(361,'1227','성형으로 얼굴을 바꾼다면 누구의 얼굴로'),
      Subject(362,'1228','눈과 관련된 시를 적어보자'),
      Subject(363,'1229','내가 했던 용감한 행동'),
      Subject(364,'1230','올해 가장 기억에 남는 사람'),
      Subject(365,'1231','나의 한해를 돌아보자'),
    ];
    await FirebaseFirestore.instance.collection('subject_list').where('class_code', isEqualTo: GetStorage().read('class_code'))
        .get().then((QuerySnapshot snapshot) async {
      // Subject(0,'0101','나의 새해 목표'),
      snapshot.docs.forEach((doc) {
        subjects.removeWhere((subject) => subject.id == doc['id']);
        subjects.add(Subject(doc['id'],doc['mmdd'],doc['subject']));
      });
    });
    /// 주제목록 가져오기
    subjects.sort((a, b) => a.mmdd.compareTo(b.mmdd));
    /// 처음 보여줄 날짜
    await getCurrentPage();

  }

  Future<void> getCurrentPage() async{
    String yyyy_string = DateFormat('yyyy').format(DateTime.now());
    DateTime yyyymmdd_datetime = DateTime.parse(yyyy_string + mmdd);
    String month = DateFormat('MM').format(yyyymmdd_datetime);
    String day = DateFormat('dd').format(yyyymmdd_datetime);
    String dayofweek = DateFormat('EEE', 'ko_KR').format(yyyymmdd_datetime);
    mmdd_yoil.value = '${month}월 ${day}일(${dayofweek})';
    var currentSubject = subjects.where((s) => s.mmdd == mmdd).first;
    subject_id.value =  currentSubject.id;
    subject.value = currentSubject.subject;


    // mmdd = DateTime.now().month.toString().padLeft(2,'0') + DateTime.now().day.toString().padLeft(2,'0');
    // DateTime day_datetime = DateTime.now();
    // String month = DateFormat('MM').format(day_datetime);
    // String day = DateFormat('dd').format(day_datetime);
    // String dayofweek = DateFormat('EEE', 'ko_KR').format(day_datetime);
    // mmdd_yoil.value = '${month}월 ${day}일(${dayofweek})';
    // var initSubject = subjects.where((s) => s.mmdd == mmdd).first;
    // subject_id.value =  initSubject.id;
    // subject.value = initSubject.subject;
  }

  // String getSubjectToday() {
  //   var mmdd = DateTime.now().month.toString().padLeft(2,'0') + DateTime.now().day.toString().padLeft(2,'0');
  //   todaySubject.value = subjects.where((s) => s.mmdd == mmdd).first.subject;
  //   return todaySubject.value;
  // }

  Future<void> delComment(commment) async{
    await FirebaseFirestore.instance.collection('subject_diary').doc(subject_diary_id).update({ 'comment': FieldValue.arrayRemove([commment]) });
  }

  void addLike(number) async{
    await FirebaseFirestore.instance.collection('subject_diary').doc(subject_diary_id).update({ 'like': FieldValue.arrayUnion([number]) });
  }

  Future<void> updComment(commment) async{
    await FirebaseFirestore.instance.collection('subject_diary').doc(subject_diary_id).update({ 'comment': FieldValue.arrayRemove([commment]) });
    await FirebaseFirestore.instance.collection('subject_diary').doc(subject_diary_id)
        .update({ 'comment': FieldValue.arrayUnion([{'date': commment['date'].toDate(), 'name': GetStorage().read('name'), 'comment': comment}]) });
  }

  void delLike(number) async{
    await FirebaseFirestore.instance.collection('subject_diary').doc(subject_diary_id).update({ 'like': FieldValue.arrayRemove([number]) });

  }

  void saveComment(value) async{
    await FirebaseFirestore.instance.collection('subject_diary').doc(subject_diary_id)
        .update({ 'comment': FieldValue.arrayUnion([{'date': DateTime.now(), 'name': GetStorage().read('name'), 'comment': value}]) });
  }

  Future<void> delSubjectDiary() async{
    FirebaseFirestore.instance.collection('subject_diary').doc(subject_diary_id).delete();
  }

  Future<void> saveSubjectDiary(number) async{
    DocumentReference doc = await FirebaseFirestore.instance.collection('subject_diary')
        .add({'date': mmdd_yoil.value, 'class_code': GetStorage().read('class_code'),  'number': number, 'content': content, 'comment' : [], 'like' : [] })
        .catchError((error) { print('saveSubjectDiary() : ${error}'); });

    content = '';
  }

  Future<void> updSubjectDiary() async{
    await FirebaseFirestore.instance.collection('subject_diary').doc(subject_diary_id).update({ 'content': content});
    content = '';
  }

}

class Subject {
  int id;
  String mmdd;
  String subject;
  Subject(this.id, this.mmdd, this.subject);
}