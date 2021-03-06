require 'rails_helper'

describe "InvoiceItems API" do
  it "sends a list of invoice_items" do
     create_list(:invoice_item, 3)

      get '/api/v1/invoice_items'

      expect(response).to be_success

      invoice_items = JSON.parse(response.body)
   end

  it "can get one invoice_item by its id" do
    id = create(:invoice_item).id

    get "/api/v1/invoice_items/#{id}"

    invoice_item = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoice_item["id"]).to eq(id)
  end

  it "serializes attributes" do
    invoice_item_1 = InvoiceItem.create(quantity: 5, unit_price: 3.99, created_at: "1234", updated_at: "5678")
    expect(invoice_item_1).to have_attributes(:quantity => 5)
    expect(invoice_item_1).to have_attributes(:unit_price => 3.99)
    expect(invoice_item_1).to_not have_attributes(:updated_at => "1234")
    expect(invoice_item_1).to_not have_attributes(:created_at => "5678")
  end

  context "find method" do
    it "can find an invoice_item by its id" do
      invoice_item1 = create(:invoice_item)
      invoice_item2 = create(:invoice_item)

      get "/api/v1/invoice_items/find?id=#{invoice_item1.id}"

      result = JSON.parse(response.body)

      expect(response).to be_success
      expect(result["id"]).to eq(invoice_item1.id)
      expect(result["id"]).to_not eq(invoice_item2.id)
    end

    it "can find an invoice_item by its quantity" do
      invoice_item1 = create(:invoice_item, quantity: 1)
      invoice_item2 = create(:invoice_item, quantity: 2)

      get "/api/v1/invoice_items/find?quantity=1"

      result = JSON.parse(response.body)

      expect(response).to be_success
      expect(result["id"]).to eq(invoice_item1.id)
      expect(result["id"]).to_not eq(invoice_item2.id)
    end

    it "can find an invoice_item by its unit price" do
      invoice_item1 = create(:invoice_item, unit_price: "333.33")
      invoice_item2 = create(:invoice_item, unit_price: "444.44")

      get "/api/v1/invoice_items/find?unit_price=333.33"

      result = JSON.parse(response.body)

      expect(response).to be_success
      expect(result["id"]).to eq(invoice_item1.id)
      expect(result["id"]).to_not eq(invoice_item2.id)
    end
  end

  context "find all method" do
    it "can find all invoice_items by id" do
      invoice_item = create(:invoice_item)
      create_list(:invoice_item, 4)

      get "/api/v1/invoice_items/find_all?id=#{invoice_item.id}"

      results = JSON.parse(response.body)

      expect(response).to be_success
      expect(results.count).to eq(1)

      results.each do |result|
        expect(result["id"]).to eq(invoice_item.id)
      end
    end

    it "can find all invoice_items by their quantity" do
      invoice_items = create_list(:invoice_item, 3, quantity: 5)
      create_list(:invoice_item, 4)

      get "/api/v1/invoice_items/find_all?quantity=5"

      results = JSON.parse(response.body)

      expect(response).to be_success
      expect(results.count).to eq(3)

      results.each do |result|
        expect(result["quantity"]).to eq(5)
      end
    end

    it "can find all invoice_items by their unit_price" do
      invoice_items = create_list(:invoice_item, 5, unit_price: "333.33")
      create_list(:invoice_item, 4)

      get "/api/v1/invoice_items/find_all?unit_price=333.33"

      results = JSON.parse(response.body)

      expect(response).to be_success
      expect(results.count).to eq(5)

      results.each do |result|
        expect(result["unit_price"]).to eq("333.33")
      end
    end
  end

  context "random method" do
    it "can find a random invoice_item" do
      create_list(:invoice_item, 3)

      get '/api/v1/invoice_items/random'

      invoice_item = JSON.parse(response.body)

      expect(response).to be_success
      expect(invoice_item).to be_a(Hash)
      expect(invoice_item).to have_key("id")
      expect(invoice_item).to have_key("quantity")
      expect(invoice_item).to have_key("unit_price")
    end
  end

  context "relationship endpoints" do
    it "returns the invoice for an invoiceitem" do
			invoice = create(:invoice)
			invoice_item = create(:invoice_item, invoice_id: invoice.id)

			get "/api/v1/invoice_items/#{invoice_item.id}/invoice"

			invoice = JSON.parse(response.body)

			expect(response).to be_success
			expect(invoice_item['invoice_id']).to eq(invoice['id'])
		end

    it "returns the item for an invoiceitem" do
			item = create(:item)
			invoice_item = create(:invoice_item, item_id: item.id)

			get "/api/v1/invoice_items/#{invoice_item.id}/item"

			item = JSON.parse(response.body)

			expect(response).to be_success
			expect(invoice_item['item_id']).to eq(item['id'])
		end
  end

end
