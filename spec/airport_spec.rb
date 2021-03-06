require 'airport'

describe Airport do
let :plane {double(:plane, takeoff: nil, land: nil, status: subject)}
let :weather {double(:weather, stormy?: false)}
subject {Airport.new(weather: weather)}

  it "has no planes when it first opens" do
    expect(subject.planes).to be_empty
  end

  describe '#land' do
    it "can have a plane land at it" do
      expect(subject.land(plane)).to include plane
    end

    it "should be able to order planes to land" do
      subject.land(plane)
      expect(plane.status).to eq subject
    end

    it "stops planes landing in stormy conditions" do

      allow(weather).to receive(:stormy?) { true }
      expect{ subject.land(plane) }.to raise_error "This plane cannot land until the weather clears up"
    end

  end

  describe '#takeoff' do
    it "lets a plane take off from the airport" do
      subject.land(plane)
      expect(subject.takeoff(plane)).to eq plane
    end

    it "orders the correct plane to take off" do
      another_plane = double(:another_plane, takeoff: nil, land: nil)
      subject.land(plane)
      subject.land(another_plane)
      subject.takeoff(plane)
      expect(subject.planes).to include another_plane
    end

    it "cannot order an absent plane to take off" do
      expect { subject.takeoff(plane) }.to raise_error "That plane is not at this airport"
    end

    it "stops planes taking off in stormy conditions" do
      subject.land(plane)
      allow(weather).to receive(:stormy?) { true }
      expect{ subject.takeoff(plane) }.to raise_error "This plane cannot take off until the weather clears up"
    end

  end

  it "should be able to expect a plane" do
    expect(subject).to respond_to :expect_plane
  end

  it "should be able to send planes to the runway" do
    expect(subject).to respond_to :send_to_runway
  end

  describe 'initialisation' do

    it "defaults the capacity to 50 if other capacity not specified" do
      expect(subject.capacity).to eq Airport::DEFAULT_CAPACITY
    end

    it "sets the capacity to 10" do
      airport = Airport.new(capacity: 10)
      expect(airport.capacity).to eq 10
    end

    it "has a variable capacity" do
      Airport::DEFAULT_CAPACITY.times { subject.land(plane) }
    expect { subject.land(plane) }.to raise_error "This airport is full"
    end

    it "has a variable capacity" do
      subject.capacity = 100
      100.times { subject.land(plane) }
    expect { subject.land(plane) }.to raise_error "This airport is full"
    end


  end




end
