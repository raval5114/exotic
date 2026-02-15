import 'dart:convert';

String? asString(dynamic value) {
  if (value == null) return null;
  return value.toString();
}

String? asIntString(dynamic value) {
  if (value == null) return null;
  return int.tryParse(value.toString())?.toString();
}

String? asDoubleString(dynamic value) {
  if (value == null) return null;
  return double.tryParse(value.toString())?.toString();
}

class Variants {
  final String pid;
  final String pvid;
  final String pvname;
  final String mrpPrice;
  final String pvDiscount;
  final String pvDiscountType;
  final String pvQuantity;
  final String pvLowStock;
  final String pvSellingPrice;
  final String pvMainImage;
  final String pvGalleryImages;
  final String pvYoutubeLink;
  final String pvStatus;
  final String pvCreatedOn;
  final String pvUpdatedOn;

  Variants({
    required this.pid,
    required this.pvid,
    required this.pvname,
    required this.mrpPrice,
    required this.pvDiscount,
    required this.pvDiscountType,
    required this.pvQuantity,
    required this.pvLowStock,
    required this.pvSellingPrice,
    required this.pvMainImage,
    required this.pvGalleryImages,
    required this.pvYoutubeLink,
    required this.pvStatus,
    required this.pvCreatedOn,
    required this.pvUpdatedOn,
  });

  factory Variants.fromJson(Map<String, dynamic> e) {
    return Variants(
      pid: asString(e["p_id"]) ?? "",
      pvid: asString(e["pv_id"]) ?? "",
      pvname: asString(e["pv_name"]) ?? "",
      mrpPrice: asDoubleString(e["pv_mrp_price"]) ?? "0",
      pvDiscount: asDoubleString(e["pv_discount"]) ?? "0",
      pvDiscountType: asIntString(e["pv_discount_type"]) ?? "0",
      pvQuantity: asIntString(e["pv_quantity"]) ?? "0",
      pvLowStock: asIntString(e["pv_low_stock"]) ?? "0",
      pvSellingPrice: asDoubleString(e["pv_selling_price"]) ?? "0",
      pvMainImage: asString(e["pv_main_image"]) ?? "",
      pvGalleryImages: asString(e["pv_gallery_image"]) ?? "[]",
      pvYoutubeLink: asString(e["pv_youtube_link"]) ?? "",
      pvStatus: asString(e["pv_status"]) ?? "0",
      pvCreatedOn: asString(e["pv_created_on"]) ?? "",
      pvUpdatedOn: asString(e["pv_updated_on"]) ?? "",
    );
  }
}

class ProductModel {
  final String? pId;
  final String? pName;
  final String? pUrl;
  final String? pType;
  final String? pHsncode;
  final String? pHsncodeDetails;
  final String? pFirstCId;
  final String? pSecondCId;
  final String? pThirdCId;
  final String? pFourCId;
  final String? pFiveCId;
  final String? pSixCId;
  final String? pSevenCId;
  final String? pBrandId;
  final String? pShortDesc;
  final String? pDesc;
  final String? pUnitPrice;
  final String? pDiscountPrice;
  final String? pDiscountType;
  final String? pSellingPrice;
  final String? pQty;
  final String? pWeight;
  final String? pLength;
  final String? pWidth;
  final String? pHeight;
  final String? pNetQty;
  final String? pMaxProductByPerOrder;
  final String? pPackWeight;
  final String? pPackLength;
  final String? pPackWidth;
  final String? pPackHeight;
  final String? pPackVolume;
  final String? pManDesc;
  final String? pPackDesc;
  final String? pTags;
  final String? pSku;
  final String? pTodaysDeal;
  final String? pFlashDeal;
  final String? pMainImage;
  final String? pVideoLink;
  final String? pPdf;
  final String? pVendorId;
  final String? pCashOnDelivery;
  final String? pFreeShipping;
  final String? pShippingDays;
  final String? pWarranty;
  final String? pWarrantyNumber;
  final String? pWarrantyType;
  final String? pWarrantyDesc;
  final String? pGuarantee;
  final String? pGuaranteeNumber;
  final String? pGuaranteeType;
  final String? pGuaranteeDesc;
  final String? pStatus;
  final String? pReturn;
  final String? pReplace;
  final String? pRefundWithNonreturn;
  final String? pBrandServiceCentreReplace;
  final String? pNonreturn;
  final String? pMetaTitle;
  final String? pMetaKeyword;
  final String? pMetaDesc;
  final String? pUpdatedOn;
  final String? pIgst;
  final String? pSgst;
  final String? pCgst;
  final String? pUgst;
  final String? pAdminStatus;
  final String? pReOrder;
  final String? pPackaging;
  final String? pEstimatePickup;
  final String? pMrpPrice;
  final String? pLowStockAlert;
  final String? pDetail;
  final String? pDiscount;
  final String? pGalleryImages;
  final String? pInactiveTimestamp;
  final String? pAdminReason;
  final List<Variants>? variants;

  ProductModel({
    this.pId,
    this.pName,
    this.pUrl,
    this.pType,
    this.pHsncode,
    this.pHsncodeDetails,
    this.pFirstCId,
    this.pSecondCId,
    this.pThirdCId,
    this.pFourCId,
    this.pFiveCId,
    this.pSixCId,
    this.pSevenCId,
    this.pBrandId,
    this.pShortDesc,
    this.pDesc,
    this.pUnitPrice,
    this.pDiscountPrice,
    this.pDiscountType,
    this.pSellingPrice,
    this.pQty,
    this.pWeight,
    this.pLength,
    this.pWidth,
    this.pHeight,
    this.pNetQty,
    this.pMaxProductByPerOrder,
    this.pPackWeight,
    this.pPackLength,
    this.pPackWidth,
    this.pPackHeight,
    this.pPackVolume,
    this.pManDesc,
    this.pPackDesc,
    this.pTags,
    this.pSku,
    this.pTodaysDeal,
    this.pFlashDeal,
    this.pMainImage,
    this.pVideoLink,
    this.pPdf,
    this.pVendorId,
    this.pCashOnDelivery,
    this.pFreeShipping,
    this.pShippingDays,
    this.pWarranty,
    this.pWarrantyNumber,
    this.pWarrantyType,
    this.pWarrantyDesc,
    this.pGuarantee,
    this.pGuaranteeNumber,
    this.pGuaranteeType,
    this.pGuaranteeDesc,
    this.pStatus,
    this.pReturn,
    this.pReplace,
    this.pRefundWithNonreturn,
    this.pBrandServiceCentreReplace,
    this.pNonreturn,
    this.pMetaTitle,
    this.pMetaKeyword,
    this.pMetaDesc,
    this.pUpdatedOn,
    this.pIgst,
    this.pSgst,
    this.pCgst,
    this.pUgst,
    this.pAdminStatus,
    this.pReOrder,
    this.pPackaging,
    this.pEstimatePickup,
    this.pMrpPrice,
    this.pLowStockAlert,
    this.pDetail,
    this.pDiscount,
    this.pGalleryImages,
    this.pInactiveTimestamp,
    this.pAdminReason,
    this.variants,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final variantJson = json['variants'] as List? ?? [];

    return ProductModel(
      pId: asIntString(json['p_id']),
      pName: asString(json['p_name']),
      pUrl: asString(json['p_url']),
      pType: asIntString(json['p_type']),
      pHsncode: asString(json['p_hsncode']),
      pHsncodeDetails: asString(json['p_hsncode_details']),

      pFirstCId: asIntString(json['p_first_c_id']),
      pSecondCId: asIntString(json['p_second_c_id']),
      pThirdCId: asIntString(json['p_third_c_id']),
      pFourCId: asIntString(json['p_four_c_id']),
      pFiveCId: asIntString(json['p_five_c_id']),
      pSixCId: asIntString(json['p_six_c_id']),
      pSevenCId: asIntString(json['p_seven_c_id']),

      pBrandId: asIntString(json['p_brand_id']),
      pShortDesc: asString(json['p_short_desc']),
      pDesc: asString(json['p_desc']),

      pUnitPrice: asDoubleString(json['p_unit_price']),
      pDiscountPrice: asDoubleString(json['p_discount_price']),
      pDiscountType: asIntString(json['p_discount_type']),
      pSellingPrice: asDoubleString(json['p_selling_price']),

      pQty: asIntString(json['p_qty']),
      pWeight: asDoubleString(json['p_weight']),
      pLength: asDoubleString(json['p_length']),
      pWidth: asDoubleString(json['p_width']),
      pHeight: asDoubleString(json['p_height']),

      pNetQty: asIntString(json['p_net_qty']),
      pMaxProductByPerOrder: asIntString(json['p_max_product_by_per_order']),

      pPackWeight: asDoubleString(json['p_pack_weight']),
      pPackLength: asDoubleString(json['p_pack_length']),
      pPackWidth: asDoubleString(json['p_pack_width']),
      pPackHeight: asDoubleString(json['p_pack_height']),
      pPackVolume: asDoubleString(json['p_pack_volume']),

      pManDesc: asString(json['p_man_desc']),
      pPackDesc: asString(json['p_pack_desc']),
      pTags: asString(json['p_tags']),
      pSku: asString(json['p_sku']),

      pTodaysDeal: asIntString(json['p_todays_deal']),
      pFlashDeal: asIntString(json['p_flash_deal']),

      pMainImage: asString(json['p_main_image']),
      pVideoLink: asString(json['p_video_link']),
      pPdf: asString(json['p_pdf']),
      pVendorId: asIntString(json['p_vendor_id']),

      pCashOnDelivery: asIntString(json['p_cash_on_delivery']),
      pFreeShipping: asIntString(json['p_free_shipping']),
      pShippingDays: asString(json['p_shipping_days']),

      pWarranty: asIntString(json['p_warranty']),
      pWarrantyNumber: asString(json['p_warranty_number']),
      pWarrantyType: asIntString(json['p_warranty_type']),
      pWarrantyDesc: asString(json['p_warranty_desc']),

      pGuarantee: asIntString(json['p_guarantee']),
      pGuaranteeNumber: asString(json['p_guarantee_number']),
      pGuaranteeType: asIntString(json['p_guarantee_type']),
      pGuaranteeDesc: asString(json['p_guarantee_desc']),

      pStatus: asIntString(json['p_status']),
      pReturn: asIntString(json['p_return']),
      pReplace: asIntString(json['p_replace']),
      pRefundWithNonreturn: asIntString(json['p_refund_with_nonreturn']),
      pBrandServiceCentreReplace: asIntString(
        json['p_brand_service_centre_replace'],
      ),
      pNonreturn: asIntString(json['p_nonreturn']),

      pMetaTitle: asString(json['p_meta_title']),
      pMetaKeyword: asString(json['p_meta_keyword']),
      pMetaDesc: asString(json['p_meta_desc']),

      pUpdatedOn: asString(json['p_updated_on']),

      pIgst: asDoubleString(json['p_igst']),
      pSgst: asDoubleString(json['p_sgst']),
      pCgst: asDoubleString(json['p_cgst']),
      pUgst: asDoubleString(json['p_ugst']),

      pAdminStatus: asString(json['p_admin_status']),
      pReOrder: asString(json['p_re_order']),
      pPackaging: asString(json['p_packaging']),
      pEstimatePickup: asString(json['p_estimate_pickup']),

      pMrpPrice: asDoubleString(json['p_mrp_price']),
      pLowStockAlert: asIntString(json['p_low_stock_alert']),

      pDetail: asString(json['p_detail']),
      pDiscount: asDoubleString(json['p_discount']),
      pGalleryImages: asString(json['p_gallery_images']),

      pInactiveTimestamp: asString(json['p_inactive_timestamp']),
      pAdminReason: asString(json['p_admin_reason']),

      variants:
          variantJson
              .map((e) => Variants.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }
}
