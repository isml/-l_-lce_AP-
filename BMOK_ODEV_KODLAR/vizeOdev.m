clear all;
#BU KISIMDA RESIMLER OKUNARAK DEGIKENE ATANMISTIR[3-4]
AnaResim = imread("C:/Users/ismail/Desktop/BMOKodev/e.jpg");
ArkaPlan = imread("C:/Users/ismail/Desktop/BMOKodev/bge.jpg");
#BU KISIMDA ANA RESIMIN RENK UZAYI RGB DEN HSV YE �EVRILMISTIR[8]
#SATIR VE S�TUN DEGERLERI DEGISKENE AKTARILMISTIR[9-10]
#HSV YE D�N�SM�S OLAN RESMIN  HUE,SATURATION VE VALUE KISIMLARI DEGISKENLERE
#AKTARILMISTIR[11-12-13]
AnaResimHSV = rgb2hsv(AnaResim);
sat = size(AnaResimHSV)(1);
sut = size(AnaResimHSV)(2);
hueI = AnaResimHSV(:,:,1);
satI = AnaResimHSV(:,:,2);
valI = AnaResimHSV(:,:,3);
#BURADA YAPILACAK MASKELEMENIN HUE,SATURATION,VALUE DEGERLERI YESIL RENGINI
#MASKELEMEK I�IN MAKSIMUM VE MINIMUM DEGERLERI TANIMLANMISTIR[16-21]
#graythresh KOMUTU G�R�NT�DEKI PARLAKLIK ESIGINI OTOMATIK OLARAK BELIRLER 0 ILE 
#1 ARASINDA BIR SAYI ATAR BU AMA�LA KULLANILMISTIR
hueMin = 0;
hueMax = graythresh(hueI);
satMin = graythresh(satI);
satMax = 1.0;
valMin = graythresh(valI);
valMax = 1.0;
#BU KISIMDA MASKELEME I�IN GEREKLI KOSULLAR BELIRLENMISTIR[23-25]
hueMask = (hueI >= hueMin) & (hueI <= hueMax);
satMask = (satI >= satMin) & (satI <= satMax);
valMask = (valI >= valMin) & (valI <= valMax);
#�� AYRI KATMAN I�IN YAPILAN MASKELEME FILTRELERI BIRLESITIRILIP UINT8 FORMATINA
#D�N�ST�R�LEREK MASKELE MATRISI OLUSMUSTUR[27-28]
Maskeleme = uint8(hueMask & satMask & valMask);
maskAnaResim = AnaResim.*Maskeleme;
#ANA RESMI MASKELEMEK I�IN MASKELEME OLARAK TANIMLANAN MATRIS ILE �ARPILMISTIR 
#VE DAHA SONRA MASKELENMIS RESIM KAYDEDILMISTIR[30]
imwrite(maskAnaResim,"C:/Users/ismail/Desktop/BMOKodev/maskelenmisAnaResim.jpg");
#MASKELENMII ANA RESIM HSV UZAYINA D�ND�R�LM�ST�R[33]
#MASKELENEN VE HSV OLAN ANA RESMIN SATURATION KATMANI DEGISKENE 
#AKTARILMISTIR[34]
maskAnaResimRGB = rgb2hsv(maskAnaResim);
maskARsat=uint8(255*maskAnaResimRGB(:,:,3));
#�N PLANA KOYULACAK OLAN RESIM I�IN ESIK DEGERINE G�RE VALUE KATMANI 
#KULLANILARAK MASKELEME ISLEMI YAPILMISTIR[36-45]
esik=150;
for i=1:sat
  for j=1:sut
    if maskARsat(i,j)<=esik
      mask1(i,j)=1;
    else
      mask1(i,j)=0;
    end
  end
end
#BURADA MASKELENEN RESIM ILE ANA RESIM �ARPILIR VE SONU� OLARAK MASKELENMIS 
#OLAN RESIMDE YESIL OLAN ARKA PLAN KISIMLARI SIYAH YANI 0 OLDUGUNDAN
#ANA RESIMDEKI YESIL OLAN HERYERI SIYAH YAPACAKTIR[48-52]
imwrite(mask1,"C:/Users/ismail/Desktop/BMOKodev/OnyuzMaskeleme.jpg");
FG(:,:,1)=mask1.*AnaResim(:,:,1);
FG(:,:,2)=mask1.*AnaResim(:,:,2);
FG(:,:,3)=mask1.*AnaResim(:,:,3);
imwrite(FG,"C:/Users/ismail/Desktop/BMOKodev/OnYuz.jpg");
#DAHA SONRA ARKA PLAN I�IN ESIK DEGERINE G�RE SATURATION KATMANI KULLANILARAK 
#MASKELEME ISLEMI YAPILMISTIR[54-62]
for i=1:sat
  for j=1:sut
    if maskARsat(i,j)>=esik
      mask2(i,j)=1;
    else
      mask2(i,j)=0;
    end
  end
end
#BURADA MASKELENEN RESIM ILE ARKA PLAN RESMI�ARPILIR VE SONU� OLARAK 
#MASKELENMIS OLAN RESIMDE YESIL OLMAYAN KISIMLAR SIYAH YANI 0 OLDUIUNDAN
#ARKA PLAN  RESMINDEKI YESIL OLMAYAN OLAN HERYERI SIYAH YAPACAKTIR[65-69]
imwrite(mask2,"C:/Users/ismail/Desktop/BMOKodev/ArkaPlanMaskeleme.jpg");
BG(:,:,1)=mask2.*ArkaPlan(:,:,1);
BG(:,:,2)=mask2.*ArkaPlan(:,:,2);
BG(:,:,3)=mask2.*ArkaPlan(:,:,3);
imwrite(BG,"C:/Users/ismail/Desktop/BMOKodev/ArkaPlan.jpg");
#SON OLARAK ELIMIZDE AYNI BOYUTLARA SAHIP �N Y�Z VE ARKA Y�Z OLMAK �ZERE 
#MASKELENMIS IKI RESIM BULUNMAKTADIR
#BU IKI RESMI TOPLAYARAK ARKA PLANI YESIL OLAN RESMIN ARKA PLANINI ARKA PLAN 
#RESMINE D�N�S�T�RM�S OLURUZ[72-73]
SON = FG+BG;
imwrite(SON,"C:/Users/ismail/Desktop/BMOKodev/SON.jpg");