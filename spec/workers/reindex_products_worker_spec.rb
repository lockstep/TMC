describe ReindexProductsWorker do
  fixtures :products

  before do
    Sidekiq::Testing.inline!
    @flamingo = products(:flamingo)
    @ostrich = products(:ostrich)
    @flamingo_double = double(reindex: true)
    @ostrich_double = double(reindex: true)
    allow(Product).to receive(:find)
      .with(@flamingo.id).and_return(@flamingo_double)
    allow(Product).to receive(:find)
      .with(@ostrich.id).and_return(@ostrich_double)
  end

  context 'gets passed an array' do
    it 'reindexes the respective products' do
      ReindexProductsWorker.perform_async([@flamingo.id, @ostrich.id])
      expect(@flamingo_double).to have_received(:reindex)
      expect(@ostrich_double).to have_received(:reindex)
    end
  end
end
