import ballerina/http;
import ballerina/uuid;

configurable int port = 8080;

enum CakeKind {
    BUTTER_CAKE = "Butter Cake",
    CHOCOLATE_CAKE = "Chocolate Cake",
    TRES_LECHES = "Tres Leches"
}

const map<int> MENU = {
    "Butter Cake": 15,
    "Chocolate Cake": 20,
    "Tres Leches": 25
};

enum OrderStatus {
    PENDING = "pending",
    IN_PROGRESS = "in progress",
    COMPLETED = "completed"
}

type OrderDetail record {|
    CakeKind item;
    int quantity;
|};

type Order record {|
    string username;
    OrderDetail[] order_items;
|};

type OrderUpdate record {|
    OrderDetail[] order_items;
|};

map<Order> orders = {};
map<OrderStatus> orderStatus = {};

service on new http:Listener(port) {
    resource function get menu() returns MENU => MENU;

    resource function post 'order(@http:Payload Order & readonly newOrder) returns http:Created|http:BadRequest|error {
        var isValidUsername = validateUsername(newOrder.username);
        if isValidUsername !is () {
            return <http:BadRequest>{body: isValidUsername};
        }

        var isValidOrderItems = validateOrderItems(newOrder.order_items);
        if isValidOrderItems !is () {
            return <http:BadRequest>{body: isValidOrderItems};
        }

        var orderId = check generateOrderId();
        var total = computeSum(newOrder.order_items);
        orders[orderId] = newOrder;
        orderStatus[orderId] = PENDING;

        return <http:Created>{body: {order_id: orderId, total}};
    }

    resource function get 'order/[string orderId]() returns http:Ok|http:NotFound {
        var status = orderStatus[orderId];
        if status is () {
            return <http:NotFound>{};
        }
        return <http:Ok>{body: {order_id: orderId, status}};
    }

    resource function put 'order/[string orderId](@http:Payload OrderUpdate & readonly updatedOrder) returns http:Ok|http:BadRequest|http:Forbidden|http:NotFound {
        var status = orderStatus[orderId];
        if status is () {
            return <http:NotFound>{};
        }
        if status != PENDING {
            return <http:Forbidden>{};
        }

        var isValidOrderItems = validateOrderItems(updatedOrder.order_items);
        if isValidOrderItems !is () {
            return <http:BadRequest>{body: isValidOrderItems};
        }

        var 'order = <Order>orders[orderId];
        var total = computeSum(updatedOrder.order_items);
        orders[orderId] = {
            username: 'order.username,
            order_items: updatedOrder.order_items
        };

        return <http:Ok>{body: {order_id: orderId, total}};
    }

    resource function delete 'order/[string orderId]() returns http:Ok|http:Forbidden|http:NotFound {
        var status = orderStatus[orderId];
        if status is () {
            return <http:NotFound>{};
        }
        if status != PENDING {
            return <http:Forbidden>{};
        }

        var _ = orders.remove(orderId);
        var _ = orderStatus.remove(orderId);
        return <http:Ok>{};
    }
}

function generateOrderId() returns string|error {
    return uuid:createType4AsString();
}

function computeSum(OrderDetail[] items) returns int {
    int total = 0;
    foreach var item in items {
        total += item.quantity * <int>MENU[item.item];
    }
    return total;
}

function validateUsername(string username) returns string? {
    if username.length() == 0 {
        return "username is empty";
    }
    return ();
}

function validateOrderItems(OrderDetail[] order_items) returns string? {
    if order_items.length() == 0 {
        return "order_items is empty";
    }
    map<boolean> orderItemFounded = {};
    foreach var item in order_items {
        if item.quantity <= 0 {
            return "negative order quatity in order_items";
        }
        if orderItemFounded.hasKey(item.item) {
            return "multiple order item in order_items";
        }
        orderItemFounded[item.item] = true;
    }
    return ();
}

