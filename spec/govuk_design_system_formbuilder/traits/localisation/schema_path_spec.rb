def justify(arr)
  arr.to_s.ljust(30, ' ')
end

describe GOVUKDesignSystemFormBuilder::Traits::Localisation do
  let(:base_name_regexp) { GOVUKDesignSystemFormBuilder::Traits::Localisation::BASE_NAME_REGEXP }

  describe "BASE_NAME_REGEXP" do
    {
      "[a][b][c]"                  => %w[a b c],
      "[a_b][b_c][c_d]"            => %w[a_b b_c c_d],
      "[a][0][b][c]"               => %w[a b c],
      "[a][0][b][0][c]"            => %w[a b c],
      "[a_b][0][c_d][0][d_e]"      => %w[a_b c_d d_e],
      "[a][0][bbb0][c]"            => %w[a bbb0 c],

      "[a][_][b]"                  => %w[a b],
      "[a][___][b]"                => %w[a b],
      "[a][?][b]"                  => %w[a b],
      "[a][string with spaces][b]" => %w[a string with spaces b],
    }.each do |input, expected|
      specify "#{justify(input)} => #{expected}" do
        expect(input.scan(base_name_regexp)).to eql(expected)
      end
    end
  end
end
