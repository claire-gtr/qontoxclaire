describe "Redirections", type: :request do

  context "redirects correctly" do
    it "redirects to the correct path with the correct status" do
      get "/de/company-creation"
      expect(response.status).to eq(301)
      expect(response).to redirect_to("/de/capital-deposit")
    end

    it "redirects to an external url with the correct status" do
      get "/en/vouchers"
      expect(response.status).to eq(301)
      expect(response).to redirect_to("https://help.qonto.com/en/articles/4460395-voucher-terms-and-conditions")
    end

    it "redirects to the correct path with the correct status and removes the trailing slash" do
      get "/de/sme/firmenkonto-worauf-ist-zu-achten/"
      expect(response.status).to eq(302)
      expect(response).to redirect_to("/de/open-an-account/firmenkonto")
    end
  end
end