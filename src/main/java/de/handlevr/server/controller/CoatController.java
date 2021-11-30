package de.handlevr.server.controller;

import de.handlevr.server.domain.Coat;
import de.handlevr.server.repository.RecordingRepository;
import de.handlevr.server.repository.CoatRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@RestController
public class CoatController {

    @Autowired
    RecordingRepository recordingRepository;
    @Autowired
    CoatRepository coatRepository;

    @GetMapping("/coats")
    public List<Coat> getCoats() {
        return coatRepository.findAll();
    }

    @GetMapping("/coats/{id}")
    public Coat getCoat(@PathVariable Long id) {
        return coatRepository.findById(id).orElseThrow(() ->
                new ResponseStatusException(HttpStatus.NOT_FOUND, String.format("Coat with the id %s not found", id)));
    }

    @DeleteMapping("/coats/{id}")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher')")
    public void deleteCoat(@PathVariable Long id) {
        Coat coat = getCoat(id);
        if (recordingRepository.existsByCoat(coat) || recordingRepository.existsByBaseCoat(coat))
            throw new ResponseStatusException(HttpStatus.CONFLICT, "RECORDING");
        if (!coat.getUsedInTasks().isEmpty())
            throw new ResponseStatusException(HttpStatus.CONFLICT, "TASK");
        coatRepository.deleteById(id);
    }

    @PutMapping(path = "/coats")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher')")
    public Coat updateCoat(@RequestBody Coat updatedCoat) {
        Coat coat = getCoat(updatedCoat.getId());
        if (recordingRepository.existsByCoat(coat) || recordingRepository.existsByBaseCoat(coat))
            throw new ResponseStatusException(HttpStatus.CONFLICT, "RECORDING");
        return coatRepository.save(updatedCoat);
    }

    @PostMapping("/coats")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher')")
    public Coat createCoat(@RequestBody Coat newCoat) {
        newCoat.setId(null);
        return coatRepository.save(newCoat);
    }
}
