import type { Schema, Struct } from '@strapi/strapi';

export interface CartItemCartItem extends Struct.ComponentSchema {
  collectionName: 'components_cart_item_cart_items';
  info: {
    displayName: 'Cart Item';
    icon: 'shoppingCart';
  };
  attributes: {
    price: Schema.Attribute.Integer;
    product: Schema.Attribute.Relation<'oneToMany', 'api::product.product'>;
    quantity: Schema.Attribute.Integer;
  };
}

export interface OrderItemOrderItem extends Struct.ComponentSchema {
  collectionName: 'components_order_item_order_items';
  info: {
    displayName: 'orderItem';
    icon: 'bulletList';
  };
  attributes: {
    price: Schema.Attribute.Integer;
    product: Schema.Attribute.Relation<'oneToMany', 'api::product.product'>;
    quantity: Schema.Attribute.Integer;
  };
}

declare module '@strapi/strapi' {
  export module Public {
    export interface ComponentSchemas {
      'cart-item.cart-item': CartItemCartItem;
      'order-item.order-item': OrderItemOrderItem;
    }
  }
}
