import 'dart:convert';

class SingleProductModel {
  final int pId;
  final String pName;
  final String pUrl;
  final int pType;
  final String pHsncode;
  final String pHsncodeDetails;

  final int pFirstCId;
  final int pSecondCId;
  final int pThirdCId;
  final int pFourCId;
  final int pFiveCId;
  final int pSixCId;
  final int pSevenCId;

  final String pBrandId;

  final String pShortDesc;
  final String pDesc;

  final double? pUnitPrice;
  final double? pDiscountPrice;
  final int pDiscountType;
  final double pSellingPrice;

  final int pQty;
  final double pWeight;

  final double pLength;
  final double pWidth;
  final double pHeight;

  final int pNetQty;
  final int pMaxProductByPerOrder;

  final double pPackWeight;
  final double pPackLength;
  final double pPackWidth;
  final double pPackHeight;
  final double pPackVolume;

  final String pManDesc;
  final String pPackDesc;

  final String? pTags;
  final String pSku;

  final int pTodaysDeal;
  final int? pFlashDeal;

  final String pMainImage;
  final String pVideoLink;
  final String? pPdf;

  final String pVendorId;

  final int pCashOnDelivery;
  final int pFreeShipping;
  final String? pShippingDays;

  final int pWarranty;
  final String pWarrantyNumber;
  final String pWarrantyType;
  final String pWarrantyDesc;

  final int pGuarantee;
  final String pGuaranteeNumber;
  final String pGuaranteeType;
  final String pGuaranteeDesc;

  final int pStatus;
  final int pReturn;
  final int pReplace;
  final int pRefundWithNonreturn;
  final int pBrandServiceCentreReplace;
  final int pNonreturn;

  final int pReturnPolicyDays;
  final int pIsReturnable;

  final String pMetaTitle;
  final String pMetaKeyword;
  final String pMetaDesc;

  final String pUpdatedOn;

  final double pIgst;
  final double pSgst;
  final double pCgst;
  final double pUgst;

  final String pAdminStatus;
  final String pReOrder;
  final String pPackaging;
  final String pEstimatePickup;

  final double pMrpPrice;
  final int pLowStockAlert;

  final Map<String, dynamic> pDetail;
  final int pDiscount;
  final List<String> pGalleryImages;

  SingleProductModel({
    required this.pId,
    required this.pName,
    required this.pUrl,
    required this.pType,
    required this.pHsncode,
    required this.pHsncodeDetails,
    required this.pFirstCId,
    required this.pSecondCId,
    required this.pThirdCId,
    required this.pFourCId,
    required this.pFiveCId,
    required this.pSixCId,
    required this.pSevenCId,
    required this.pBrandId,
    required this.pShortDesc,
    required this.pDesc,
    this.pUnitPrice,
    this.pDiscountPrice,
    required this.pDiscountType,
    required this.pSellingPrice,
    required this.pQty,
    required this.pWeight,
    required this.pLength,
    required this.pWidth,
    required this.pHeight,
    required this.pNetQty,
    required this.pMaxProductByPerOrder,
    required this.pPackWeight,
    required this.pPackLength,
    required this.pPackWidth,
    required this.pPackHeight,
    required this.pPackVolume,
    required this.pManDesc,
    required this.pPackDesc,
    this.pTags,
    required this.pSku,
    required this.pTodaysDeal,
    this.pFlashDeal,
    required this.pMainImage,
    required this.pVideoLink,
    this.pPdf,
    required this.pVendorId,
    required this.pCashOnDelivery,
    required this.pFreeShipping,
    this.pShippingDays,
    required this.pWarranty,
    required this.pWarrantyNumber,
    required this.pWarrantyType,
    required this.pWarrantyDesc,
    required this.pGuarantee,
    required this.pGuaranteeNumber,
    required this.pGuaranteeType,
    required this.pGuaranteeDesc,
    required this.pStatus,
    required this.pReturn,
    required this.pReplace,
    required this.pRefundWithNonreturn,
    required this.pBrandServiceCentreReplace,
    required this.pNonreturn,
    required this.pReturnPolicyDays,
    required this.pIsReturnable,
    required this.pMetaTitle,
    required this.pMetaKeyword,
    required this.pMetaDesc,
    required this.pUpdatedOn,
    required this.pIgst,
    required this.pSgst,
    required this.pCgst,
    required this.pUgst,
    required this.pAdminStatus,
    required this.pReOrder,
    required this.pPackaging,
    required this.pEstimatePickup,
    required this.pMrpPrice,
    required this.pLowStockAlert,
    required this.pDetail,
    required this.pDiscount,
    required this.pGalleryImages,
  });

  factory SingleProductModel.fromJson(Map<String, dynamic> json) {
    return SingleProductModel(
      pId: json['p_id'],
      pName: json['p_name'],
      pUrl: json['p_url'],
      pType: json['p_type'],
      pHsncode: json['p_hsncode'],
      pHsncodeDetails: json['p_hsncode_details'],

      pFirstCId: json['p_first_c_id'],
      pSecondCId: json['p_second_c_id'],
      pThirdCId: json['p_third_c_id'],
      pFourCId: json['p_four_c_id'],
      pFiveCId: json['p_five_c_id'],
      pSixCId: json['p_six_c_id'],
      pSevenCId: json['p_seven_c_id'],

      pBrandId: json['p_brand_id'],
      pShortDesc: json['p_short_desc'],
      pDesc: json['p_desc'],

      pUnitPrice:
          json['p_unit_price'] != null
              ? double.tryParse(json['p_unit_price'].toString())
              : null,

      pDiscountPrice:
          json['p_discount_price'] != null
              ? double.tryParse(json['p_discount_price'].toString())
              : null,

      pDiscountType: json['p_discount_type'],
      pSellingPrice: double.parse(json['p_selling_price']),

      pQty: int.parse(json['p_qty']),
      pWeight: double.parse(json['p_weight']),
      pLength: double.parse(json['p_length']),
      pWidth: double.parse(json['p_width']),
      pHeight: double.parse(json['p_height']),

      pNetQty: int.parse(json['p_net_qty']),
      pMaxProductByPerOrder: int.parse(json['p_max_product_by_per_order']),

      pPackWeight: double.parse(json['p_pack_weight']),
      pPackLength: double.parse(json['p_pack_length']),
      pPackWidth: double.parse(json['p_pack_width']),
      pPackHeight: double.parse(json['p_pack_height']),
      pPackVolume: double.parse(json['p_pack_volume']),

      pManDesc: json['p_man_desc'],
      pPackDesc: json['p_pack_desc'],

      pTags: json['p_tags'],
      pSku: json['p_sku'],

      pTodaysDeal: json['p_todays_deal'],
      pFlashDeal: json['p_flash_deal'],

      pMainImage: json['p_main_image'],
      pVideoLink: json['p_video_link'],
      pPdf: json['p_pdf'],

      pVendorId: json['p_vendor_id'],

      pCashOnDelivery: json['p_cash_on_delivery'],
      pFreeShipping: json['p_free_shipping'],
      pShippingDays: json['p_shipping_days'],

      pWarranty: json['p_warranty'],
      pWarrantyNumber: json['p_warranty_number'],
      pWarrantyType: json['p_warranty_type'],
      pWarrantyDesc: json['p_warranty_desc'],

      pGuarantee: json['p_guarantee'],
      pGuaranteeNumber: json['p_guarantee_number'],
      pGuaranteeType: json['p_guarantee_type'],
      pGuaranteeDesc: json['p_guarantee_desc'],

      pStatus: json['p_status'],
      pReturn: json['p_return'],
      pReplace: json['p_replace'],
      pRefundWithNonreturn: json['p_refund_with_nonreturn'],
      pBrandServiceCentreReplace: json['p_brand_service_centre_replace'],
      pNonreturn: json['p_nonreturn'],

      pReturnPolicyDays: json['p_return_policy_days'],
      pIsReturnable: json['p_is_returnable'],

      pMetaTitle: json['p_meta_title'],
      pMetaKeyword: json['p_meta_keyword'],
      pMetaDesc: json['p_meta_desc'],

      pUpdatedOn: json['p_updated_on'],

      pIgst: double.parse(json['p_igst']),
      pSgst: double.parse(json['p_sgst']),
      pCgst: double.parse(json['p_cgst']),
      pUgst: double.parse(json['p_ugst']),

      pAdminStatus: json['p_admin_status'],
      pReOrder: json['p_re_order'],
      pPackaging: json['p_packaging'],
      pEstimatePickup: json['p_estimate_pickup'],

      pMrpPrice: double.parse(json['p_mrp_price']),
      pLowStockAlert: int.parse(json['p_low_stock_alert']),

      pDetail:
          json['p_detail'] != null
              ? Map<String, dynamic>.from(jsonDecode(json['p_detail']))
              : {},

      pDiscount: int.parse(json['p_discount']),
      pGalleryImages: List<String>.from(jsonDecode(json['p_gallery_images'])),
    );
  }
}
