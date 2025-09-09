# frozen_string_literal: true

require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do
  describe '#update_quality' do
    subject { GildedRose.new(items).update_quality }
    let(:name) { 'foo' }
    let(:sell_in) { 10 }
    let(:quality) { 10 }
    let(:item) { Item.new(name, sell_in, quality) }
    let(:items) { [item] }

    shared_examples 'name is preserved and sell_in decreases' do
      it 'name is preserved' do
        subject
        expect(items[0].name).to eq(name)
      end

      it 'sell_in decreases by one' do
        subject
        expect(items[0].sell_in).to eq(sell_in - 1)
      end
    end

    describe 'When the input is not an array' do
      let(:items) { nil }

      it 'throws a GildedRose::UnsupportedInput error' do
        # expect { GildedRose.new(nil).update_quality }.to raise_error(GildedRose::UnsupportedInput)
        expect { subject }.to raise_error(GildedRose::InvalidInput)
      end
    end

    describe 'When an element in the input is of invalid type' do
      let(:item) { nil }

      it 'throws a GildedRose::UnsupportedItem error' do
        expect { subject }.to raise_error(GildedRose::InvalidItem)
      end
    end

    context 'Other than Legendary items minimum quality' do
      let(:quality) { 0 }

      it 'is zero' do
        subject
        expect(items[0].quality).to eq(0)
      end
    end

    context 'Other than Legendary items maximum quality' do
      let(:quality) { 50 }
      let(:name) { 'Aged Brie' } # increases by time

      it 'is 50' do
        subject
        expect(items[0].quality).to eq(50)
      end
    end

    context 'Ordinary item' do
      it_behaves_like 'name is preserved and sell_in decreases'

      context 'Before the sell_in date' do
        it 'quality decreases by one' do
          subject
          expect(items[0].quality).to eq(quality - 1)
        end
      end

      context 'After the sell_in date' do
        let(:sell_in) { -1 }

        it 'quality decreases twice as fast' do
          subject
          expect(items[0].quality).to eq(quality - 2)
        end
      end
      context 'Conjured ordinary item' do
        let(:name) { 'Conjured foo' }

        context 'Before the sell_in date' do
          it 'quality decreases by two' do
            subject
            expect(items[0].quality).to eq(quality - 2)
          end
        end

        context 'After the sell_in date' do
          let(:sell_in) { -1 }

          it 'quality decreases twice as fast' do
            subject
            expect(items[0].quality).to eq(quality - 4)
          end
        end
      end
    end

    context 'Aged item' do
      let(:name) { 'Aged Brie' }

      it_behaves_like 'name is preserved and sell_in decreases'

      context 'Before the sell_in date' do
        it 'quality increases by one' do
          subject
          expect(items[0].quality).to eq(quality + 1)
        end
      end

      context 'After the sell_in date' do
        let(:sell_in) { -1 }

        it 'quality increases by two' do
          subject
          expect(items[0].quality).to eq(quality + 2)
        end
      end
      context 'Conjured Aged item' do
        let(:name) { 'Conjured Aged Brie' }

        context 'Before the sell_in date' do
          it 'increases by two' do
            subject
            expect(items[0].quality).to eq(quality + 2)
          end
        end

        context 'After the sell_in date' do
          let(:sell_in) { -1 }

          it 'quality increases twice as fast' do
            subject
            expect(items[0].quality).to eq(quality + 4)
          end
        end
      end
    end

    context 'Legendary item' do
      let(:quality) { 80 }
      let(:name) { 'Sulfuras, Hand of Ragnaros' }

      context 'When quality is other than 80' do
        let(:quality) { 10 }

        it 'raises LegendaryItem::InvalidQuality' do
          expect { subject }.to raise_error(LegendaryItem::InvalidQuality)
        end
      end

      it 'sell_in does not change' do
        subject
        expect(items[0].sell_in).to eq(sell_in)
      end

      it 'name is preserved' do
        subject
        expect(items[0].name).to eq(name)
      end

      it 'quality is 80' do
        subject
        expect(items[0].quality).to eq(80)
      end

      context 'Conjured Legendary item' do
        let(:quality) { 80 }
        let(:name) { 'Conjured Sulfuras, Hand of Ragnaros' }

        it 'sell_in does not change' do
          subject
          expect(items[0].sell_in).to eq(sell_in)
        end

        it 'quality is always 80' do
          subject
          expect(items[0].quality).to eq(80)
        end
      end
    end

    context 'Admission item' do
      let(:name) { 'Backstage passes to a TAFKAL80ETC concert' }

      it_behaves_like 'name is preserved and sell_in decreases'

      context 'More than ten days before the event' do
        let(:sell_in) { 20 }

        it 'quality increases by one' do
          subject
          expect(items[0].quality).to eq(quality + 1)
        end
      end

      context 'Ten days but more than five days before the event' do
        let(:sell_in) { 9 }

        it 'quality increases by two' do
          subject
          expect(items[0].quality).to eq(quality + 2)
        end
      end

      context 'Five days or less before the event' do
        let(:sell_in) { 4 }

        it 'quality increases by three' do
          subject
          expect(items[0].quality).to eq(quality + 3)
        end
      end

      context 'After the event' do
        let(:sell_in) { -1 }

        it 'quality is zero' do
          subject

          expect(items[0].quality).to eq(0)
        end
      end
      context 'Conjured Admission item' do
        let(:name) { 'Conjured Backstage passes to a TAFKAL80ETC concert' }

        context 'More than ten days before the event' do
          let(:sell_in) { 20 }

          it 'quality increases by two' do
            subject
            expect(items[0].quality).to eq(quality + 2)
          end
        end

        context 'Ten days but more than five days before the event' do
          let(:sell_in) { 9 }

          it 'quality increases by four' do
            subject
            expect(items[0].quality).to eq(quality + 4)
          end
        end

        context 'Five days or less before the event' do
          let(:sell_in) { 4 }

          it 'quality increases by six' do
            subject
            expect(items[0].quality).to eq(quality + 6)
          end
        end

        context 'After the event' do
          let(:sell_in) { -1 }

          it 'quality is zero' do
            subject

            expect(items[0].quality).to eq(0)
          end
        end
      end
    end
  end
end
