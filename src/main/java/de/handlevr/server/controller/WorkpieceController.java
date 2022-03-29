package de.handlevr.server.controller;

import de.handlevr.server.domain.Workpiece;
import de.handlevr.server.repository.WorkpieceRepository;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * Handles all workpiece requests.
 */
@RestController
public class WorkpieceController {

    final WorkpieceRepository workpieceRepository;

    public WorkpieceController(WorkpieceRepository workpieceRepository) {
        this.workpieceRepository = workpieceRepository;
    }

    @GetMapping("/workpieces")
    public List<Workpiece> getWorkpieces() {
        return workpieceRepository.findAll();
    }
}
