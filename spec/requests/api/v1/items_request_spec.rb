require 'rails_helper'

describe "Items API" do
  it "sends a list of items" do
     create_list(:item, 3)

      get '/api/v1/items'

      expect(response).to be_success

      items = JSON.parse(response.body)

      expect(items.count).to eq(3)
   end

  it "can get one item by its id" do
    id = create(:item).id

    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body)

    expect(response).to be_success
    expect(item["id"]).to eq(id)
  end

  it "serializes attributes" do
    created = "2017-01-01T00:00:00.000Z"
    updated = "2017-02-01T00:00:00.000Z"
    item_1 = Item.create(
      name: "kurig",
      description: "make brewing coffee easier",
      unit_price: 58.99,
      merchant_id: 7,
      created_at: created,
      updated_at: updated
    )
    expect(item_1).to have_attributes(:name => "kurig")
    expect(item_1).to have_attributes(:description => "make brewing coffee easier")
    expect(item_1).to have_attributes(:unit_price => 58.99)
    expect(item_1).to have_attributes(:merchant_id => 7)
    expect(item_1).to_not have_attributes(:created_at => created)
    expect(item_1).to_not have_attributes(:updated_at => updated)
  end

  context "find method" do
    it "can find an item by its id" do
      item1 = create(:item)
      item2 = create(:item)

      get "/api/v1/items/find?id=#{item1.id}"

      result = JSON.parse(response.body)

      expect(response).to be_success
      expect(result["id"]).to eq(item1.id)
      expect(result["id"]).to_not eq(item2.id)
    end

    it "can find an item by its name" do
      item1 = create(:item, name: "legos")
      item2 = create(:item)

      get "/api/v1/items/find?name=legos"

      result = JSON.parse(response.body)

      expect(response).to be_success
      expect(result["id"]).to eq(item1.id)
      expect(result["id"]).to_not eq(item2.id)
    end

    it "can find an item by its description" do
      item1 = create(:item, description: "awesome")
      item2 = create(:item)

      get "/api/v1/items/find?description=awesome"

      result = JSON.parse(response.body)

      expect(response).to be_success
      expect(result["id"]).to eq(item1.id)
      expect(result["id"]).to_not eq(item2.id)
    end

    it "can find an item by its unit price" do
      item1 = create(:item, unit_price: 45.99)
      item2 = create(:item)

      get "/api/v1/items/find?unit_price=45.99"

      result = JSON.parse(response.body)

      expect(response).to be_success
      expect(result["id"]).to eq(item1.id)
      expect(result["id"]).to_not eq(item2.id)
    end

    it "can find an item by its merchant id" do
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)
      item1 = create(:item, merchant: merchant1)
      item2 = create(:item, merchant: merchant2)

      get "/api/v1/items/find?merchant_id=#{merchant1.id}"

      result = JSON.parse(response.body)

      expect(response).to be_success
      expect(result["id"]).to eq(item1.id)
      expect(result["id"]).to_not eq(item2.id)
    end

    it "can find an item by when it was created" do
      created = "2017-01-01T00:00:00.000Z"
      item1 = create(:item, created_at: created)
      item2 = create(:item)

      get "/api/v1/items/find?created_at=#{created}"

      result = JSON.parse(response.body)

      expect(response).to be_success
      expect(result["id"]).to eq(item1.id)
      expect(result["id"]).to_not eq(item2.id)
    end

    it "can find an item by when it was updated" do
      updated = "2017-02-01T00:00:00.000Z"
      item1 = create(:item, updated_at: updated)
      item2 = create(:item)

      get "/api/v1/items/find?updated_at=#{updated}"

      result = JSON.parse(response.body)

      expect(response).to be_success
      expect(result["id"]).to eq(item1.id)
      expect(result["id"]).to_not eq(item2.id)
    end
  end

  context "find all method" do
    it "can find all items by id" do
      item = create(:item)
      create_list(:item, 4)

      get "/api/v1/items/find_all?id=#{item.id}"

      results = JSON.parse(response.body)

      expect(response).to be_success
      expect(results.count).to eq(1)

      results.each do |result|
        expect(result["id"]).to eq(item.id)
      end
    end

    it "can find all items by their name" do
      items = create_list(:item, 3, name: "iphone")
      create_list(:item, 4)

      get "/api/v1/items/find_all?name=iphone"

      results = JSON.parse(response.body)

      expect(response).to be_success
      expect(results.count).to eq(3)

      results.each do |result|
        expect(result["name"]).to eq("iphone")
      end
    end

    it "can find all items by their description" do
      items = create_list(:item, 5, description: "in white or black")
      create_list(:item, 4)

      get "/api/v1/items/find_all?description=in white or black"

      results = JSON.parse(response.body)

      expect(response).to be_success
      expect(results.count).to eq(5)

      results.each do |result|
        expect(result["description"]).to eq("in white or black")
      end
    end

    it "can find all items by their unit price" do
      items = create_list(:item, 3, unit_price: 333.99)
      create_list(:item, 4)

      get "/api/v1/items/find_all?unit_price=333.99"

      results = JSON.parse(response.body)

      expect(response).to be_success
      expect(results.count).to eq(3)

      results.each do |result|
        expect(result["unit_price"]).to eq("333.99")
      end
    end

    it "can find all items by their merchant id" do
      merchant = create(:merchant)
      items = create_list(:item, 3, merchant: merchant)
      create_list(:item, 4)

      get "/api/v1/items/find_all?merchant_id=#{merchant.id}"

      results = JSON.parse(response.body)

      expect(response).to be_success
      expect(results.count).to eq(3)

      results.each do |result|
        expect(result["merchant_id"]).to eq(merchant.id)
      end
    end

    it "can find all items by when they were created" do
      created = "2017-01-01T00:00:00.000Z"
      items = create_list(:item, 2, created_at: created)
      create_list(:item, 4)

      get "/api/v1/items/find_all?created_at=#{created}"

      results = JSON.parse(response.body)

      expect(response).to be_success
      expect(results.count).to eq(2)

      expect(results.first["id"]).to eq(items.first.id)
      expect(results.second["id"]).to eq(items.second.id)
    end

    it "can find all items by when they were updated" do
      updated = "2017-02-01T00:00:00.000Z"
      items = create_list(:item, 3, updated_at: updated)
      create_list(:item, 2)

      get "/api/v1/items/find_all?updated_at=#{updated}"

      results = JSON.parse(response.body)

      expect(response).to be_success
      expect(results.count).to eq(3)

      expect(results.first["id"]).to eq(items.first.id)
      expect(results.second["id"]).to eq(items.second.id)
      expect(results.third["id"]).to eq(items.third.id)
    end
  end

  context "random method" do
    it "can find a random item" do
      create_list(:item, 3)

      get '/api/v1/items/random'

      item = JSON.parse(response.body)

      expect(response).to be_success
      expect(item).to be_a(Hash)
      expect(item).to have_key("name")
      expect(item).to have_key("description")
      expect(item).to have_key("unit_price")
      expect(item).to have_key("merchant_id")
    end
  end

  context "relationship endpoints" do
    it "returns invoice items associated with an item" do
      create(:item)
      create(:invoice_item, item: Item.first)

      get "/api/v1/items/#{Item.first.id}/invoice_items"
      item = JSON.parse(response.body)

      expect(response).to be_success
      expect(item.first["item_id"]).to eq(Item.first.id)
      expect(item.count).to eq(1)
    end

    it "returns an items merchant" do
      merchant = create(:merchant)
      merchant.items << create(:item)
      item = Item.first

      get "/api/v1/items/#{item.id}/merchant"
      merchant = JSON.parse(response.body)

      expect(response).to be_success
      expect(merchant['id']).to eq(item.merchant_id)
    end
  end

  context "business logic methods" do
    context "best day" do
      it "can return the day with the most sales for an item" do
        create_date_1 = "2017-01-01T00:00:00.000Z"
        create_date_2 = "2017-02-02T00:00:00.000Z"
        create_date_3 = "2017-03-03T00:00:00.000Z"
        item = create(:item)
        invoice_items = create_list(:invoice_item, 2, quantity: 3,
          item: item,
          invoice: create(:invoice, created_at: create_date_1)
        )
        invoice_items = create_list(:invoice_item, 2, quantity: 2,
          item: item,
          invoice: create(:invoice, created_at: create_date_2)
        )

        get "/api/v1/items/#{item.id}/best_day"
        results = JSON.parse(response.body)

        expect(response).to be_success
        expect(results['best_day']).to eq(create_date_1)
        expect(results['best_day']).to_not eq(create_date_2)
      end

      it "can return the most recent day when two days are tied with the most sales for an item" do
        create_date_1 = "2017-01-01T00:00:00.000Z"
        create_date_2 = "2017-02-02T00:00:00.000Z"
        create_date_3 = "2017-03-03T00:00:00.000Z"
        item = create(:item)
        invoice_items = create_list(:invoice_item, 2, quantity: 3,
          item: item,
          invoice: create(:invoice, created_at: create_date_1)
        )
        invoice_items = create_list(:invoice_item, 3, quantity: 2,
          item: item,
          invoice: create(:invoice, created_at: create_date_2)
        )
        invoice_items = create_list(:invoice_item, 2,
          item: item,
          invoice: create(:invoice, created_at: create_date_3)
        )

        get "/api/v1/items/#{item.id}/best_day"
        results = JSON.parse(response.body)

        expect(response).to be_success
        expect(results['best_day']).to eq(create_date_2)
        expect(results['best_day']).to_not eq(create_date_1)
        expect(results['best_day']).to_not eq(create_date_3)
      end

    it "returns the top x items ranked by total revenue generated" do
      item1 = create(:item)
      item2 = create(:item)
      invoice_1, invoice_2, invoice_3 = create_list(:invoice, 3)
      invoice_items_1 = create(:invoice_item, item: item1, invoice: invoice_1, quantity: 5, unit_price: 500)
      invoice_items_2 = create(:invoice_item, item: item2, invoice: invoice_2, quantity: 2, unit_price: 200)
      invoice_items_3 = create(:invoice_item, item: item2, invoice: invoice_3, quantity: 1, unit_price: 200)
      transaction = create(:transaction, invoice: invoice_1, result: "success")
      transaction = create(:transaction, invoice: invoice_2, result: "success")
      transaction = create(:transaction, invoice: invoice_3, result: "success")

      get "/api/v1/items/most_revenue?quantity=1"

      result = JSON.parse(response.body)

        expect(response).to be_success
        expect(result.first["id"]).to eq(item1.id)
    end

      it "returns the top items ranked by total revenue generated" do
        item_1, item_2, item_3 = create_list(:item, 3)
        invoice = create(:invoice)
        create_list(:transaction, 3, invoice: invoice, result: 'success')
        create(:invoice_item, item: item_1, invoice: invoice, quantity: 50)
        create(:invoice_item, item: item_2, invoice: invoice, quantity: 200)
        create(:invoice_item, item: item_3, invoice: invoice, quantity: 105)

        get "/api/v1/items/most_items?quantity=3"

        result = JSON.parse(response.body)

        expect(response).to be_success
        expect(result.count).to eq(3)
        expect(result.first["id"]).to eq(item_2.id)
        expect(result.last["id"]).to eq(item_1.id)
      end
    end
  end

end
